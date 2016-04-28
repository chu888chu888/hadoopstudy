# seafile服务器 
搭建环境：Ubuntu Server14.04

seafile安装版本：5.1.1

seafile下载链接：[https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_5.1.1_x86-64.tar.gz](https://bintray.com/artifact/download/seafile-org/seafile/seafile-server_5.1.1_x86-64.tar.gz)

**本次安装主机IP为192.168.1.67，如有不同请自行更改**

## 一、seafile基于MySQL安装 ##
### 1、更新源列表 ###
	sudo apt-get update
	sudo apt-get upgrade
### 2、新建用户 ###
创建一个seafile的用户

	sudo useradd seafile -m

给seafile用户创建密码
    
    sudo passwd seafile
    
赋给seafile用户sudo权限

	sudo chmod +w /etc/sudoers
	sudo vim /etc/sudoers
添加下面一行

	seafile ALL=(ALL:ALL) ALL
切换到seafile用户，并以seafile用户执行以下全部操作
### 3、安装mysql ###
	sudo apt-get install mysql-server mysql-client
按照提示输入root用户密码完成安装
### 4、安装依赖软件 ###
	sudo apt-get install python2.7 python-setuptools python-imaging python-ldap python-mysqldb python-memcache
### 5、安装seafile ###
创建安装目录（我的是在/home/seafile下面）

	mkdir seafile
	cd seafile
	tar zxvf /home/seafile/seafile-server_5.1.1_x86-64.tar.gz
	mkdir installed 
	mv /home/seafile/seafile-server_5.1.1_x86-64.tar.gz installed
这样设计目录的好处在于和 seafile 相关的配置文件都可以放在 seafile 目录下，便于集中管理.后续升级时,你只需要解压最新的安装包到 seafile 目录下.
	
	cd seafile-server-5.1.1
	./setup-seafile-mysql.sh

在安装过程中会让你回答几个问题，主要注意下面几点，其他的可以使用默认的，直接回车确认就行。

a、seafile server ip or domain,输入本机IP

b、选择一种创建 Seafile 数据库的方式：

Please choose a way to initialize seafile databases:

[1] Create new ccnet/seafile/seahub databases

[2] Use existing ccnet/seafile/seahub databases

建议选择第一种方式。输入连接数据库的一些参数，创建seafile的数据库。

参数如图   
![](http://i.imgur.com/I45vRBe.png)

### 6、启动&测试 ###
查看seafile目录，应该包含以下文件夹：

ccnet

conf

installed

seafile-data

seafile-server-5.1.1

seafile-server-latest

seahub-data

在/etc/security/limits.conf中添加下面两行

`	*	hard	nofile	65535`

`	*	soft	nofile	65535`

将/etc/pam.d/su中下面代码前的#取消
	
	session    required   pam_limits.so
启动seafile服务器（在seafile-server-5.1.1目录下）
	
	./seafile.sh start
	./seahub.sh start
第一次启动seahub服务时会创建一个管理员用户，输入管理员邮箱、密码。

在浏览器中输入 http://192.168.1.67:8000（主机ip），出现一个登陆界面证明服务正常启动。
## 二、Apache 下配置 Seahub ##
### 1、安装apache2 ###
	sudo apt-get install apache2
### 2、安装、加载依赖模块 ###
	sudo apt-get install python-flup
	sudo apt-get install libApache2-mod-fastcgi
	sudo a2enmod rewrite
	sudo a2enmod proxy_http
### 3、修改apache2配置文件 ###
修改apache2.conf（我的存放在/etc/apache2下面），在最后面添加

	FastCGIExternalServer /var/www/seahub.fcgi -host 127.0.0.1:8000
修改000-default.conf（/etc/apache2/sites-enabled）
	
	<VirtualHost *:80>
	ServerName 192.168.1.67
	DocumentRoot /var/www
	Alias /media  /home/seafile/seafile/seafile-server-latest/seahub/media
	RewriteEngine On
	<Location /media>
    	Require all granted
	</Location>
	ProxyPass /seafhttp http://127.0.0.1:8082
	ProxyPassReverse /seafhttp http://127.0.0.1:8082
	RewriteRule ^/seafhttp - [QSA,L]
	RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteRule ^(.*)$ /seahub.fcgi$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
	</VirtualHost>
在浏览器登录成功后，在**系统管理 → 设置**里面修改SERVICE_URL、FILE-SERVER-ROOT。

![](http://i.imgur.com/mpdEMMt.png)
	
	SERVICE_URL: http://192.168.1.67
	FILE_SERVER_ROOT: http://192.168.1.67/seafhttp
修改ccnet.conf（seafile/conf/）,修改SERVICE_URL。
	
	SERVICE_URL = http://192.168.1.67
修改seahub_settings.py（seafile/conf/）,在最后一行添加`FILE_SERVER_ROOT`。

	FILE_SERVER_ROOT = 'http://192.168.1.67/seafhttp'
### 4、测试 ###
重新启动apache2、seafile、seahub服务（seafile.sh和seahub.sh在/seafile/seafile-server-5.1.1目录下）
	
	sudo service apache2 restart
	./seafile.sh restart
	./seahub.sh restart-fastcgi
在浏览器中输入http://192.168.1.67，跳转到登录页面，说明服务正常启动。
## 三、开机自启动 ##
### 1、seafile启动脚本 ###
编辑/etc/init.d/seafile-server文件
	
	#!/bin/sh
	user=seafile
	seafile_dir=/home/seafile/seafile
	script_path=${seafile_dir}/seafile-server-latest
	seafile_init_log=${seafile_dir}/logs/seafile.init.log
	seahub_init_log=${seafile_dir}/logs/seahub.init.log

	fastcgi=true
	fastcgi_port=8000

	case "$1" in
	start)
		sudo -u ${user} ${script_path}/seafile.sh start >> ${seafile_init_log}
		if [ $fastcgi = true ];
		then
			sudo -u ${user} ${script_path}/seahub.sh start-fastcgi ${fastcgi_port} >> ${seahub_init_log}
		else
			sudo -u ${user} ${script_path}/seahub.sh start >> ${seahub_init_log}
		fi
	;;
	restart)
		sudo -u ${user} ${script_path}/seafile.sh restart >> ${seafile_init_log}
		if [ $fastcgi = true ]
		then
			sudo -u ${user} ${script_path}/seahub.sh restart-fastcgi ${fastcgi_port} >> ${seahub_init_log}
		else
			sudo -u ${user} ${script_path}/seahub.sh restart >> ${seahub_init_log}
		fi
	;;
	stop)
		sudo -u ${user} ${script_path}/seafile.sh $1 >> ${seafile_init_log}
		sudo -u ${user} ${script_path}/seahub.sh $1 >> ${seahub_init_log}
	;;
	*)
		echo "Usage: /etc/init.d/seafile-server {start|stop|restart}"
		exit 1
	;;
	esac
给seafile-seaver文件执行权限

	chmod +x seafile-server
编辑/etc/init/seafile-server.conf文件

	start on (started mysql
	and runlevel [2345])
	stop on (runlevel [016])

	pre-start script
	/etc/init.d/seafile-server start
	end script

	post-stop script
	/etc/init.d/seafile-server stop
	end script

## 四、数据迁移 ##
### 1、准备工作 ###
如果需要将一台服务器上的所有数据全部迁移到另外的一台服务器上，我们需要**搭建一台新的seafile服务器**。在搭建服务器的过程我们要尽量保证安装路径、安装选项、参数设置等尽量与原来的服务器保持一致。
### 2、迁移seafile资料库数据 ###
seafile资料库的数据全部存放在seafile安装目录下的seafile-date文件夹中，所以我们只需远程拷贝该文件夹中的数据到另外已经搭建好的服务器上。在新服务器上执行该命令：
	
	scp -vrp seafile@192.168.1.67:/home/seafile/seafile/seafile-data /home/seafile/seafile
### 3、迁移MySQL数据库中的数据 ###
将原来服务器中seafile的三个数据库备份到/home/seafile目录下：
	
	mysqldump -u root -p --opt ccnet-db > /home/seafile/ccnet-db.sql
	mysqldump -u root -p --opt seafile-db > /home/seafile/seafile-db.sql
	mysqldump -u root -p --opt seahub-db > /home/seafile/seahub-db.sql
在新服务器上将数据库的备份文件拷贝至本机上：

	scp seafile@192.168.1.67:/home/seafile/ccnet-db.sql /home/seafile
	scp seafile@192.168.1.67:/home/seafile/seafile-db.sql /home/seafile
	scp seafile@192.168.1.67:/home/seafile/seahub-db.sql /home/seafile
在/home/seafile目录下将数据库备份文件导入到数据库

	mysql -u root -p ccnet-db < ccnet-db.sql
	mysql -u root -p seafile-db < seafile-db.sql
	mysql -u root -p seahub-db < seahub-db.sql
如果新搭建的服务器与原来的有不一样的，请修改相应配置文件。

在浏览器中重新登录，seafile会自动同步数据。

## 五、故障 ##
### 1、 系统中已经安装了apache服务，在安装seafile是会出现安装不完全的现象，seafile目录中缺失seafile-server-latest目录###
解决方法：卸载apache服务，删除seafile文件夹，按照mysql→seafile→apace顺序重新安装。
### 2、在浏览器中打开seafile时，图片资源不能加载，提示403（Forbidden） ###
解决方法：

a、检查/etc/apache2/sites-enabled/000-default.conf文件中`Alias /media  /home/ubuntu/seafile/seafile-server-latest/seahub/media`与自己系统中的文件路径是否一致。

b、检查/etc/apache2/sites-enabled/000-default.conf文件下面代码是否有拼写错误。

	<Location /media>
    	Require all granted
	</Location>
c、检查/etc/apache2/sites-enabled/000-default.conf文件中`Alias /media  /home/ubuntu/seafile/seafile-server-latest/seahub/media`的每一级目录的权限是否正确。
### 3、在浏览器中打开seafile服务时提示“500 Internal Server Error”###
解决方法：重新启动seahub服务，并且一定要加载fastcgi，执行命令`./seahub.sh restart-fastcgi`。
### 4、apache2、seafile不能正常开机自启动，报的错误为找不到文件、目录不存在或是命令不存在，而文件都存在且都有可读权限 ###
解决方法：

在/etc/security/limits.conf中添加下面两行

`	*	hard	nofile	65535`

`	*	soft	nofile	65535`

将/etc/pam.d/su中下面代码前的#取消
	
	session    required   pam_limits.so

#磁盘扩容

查看添加的磁盘

	fdisk -l

![](http://i.imgur.com/LTNz63C.png)显示sdc没有分区表（sdc是扩容的部分）

创建物理卷
	
	pvcreate /dev/sdc
查看系统物理卷的情况

	pvdisplay

查看原VolGroup的情况，记下VG Name，Free PE/Size

	vgdisplay

![](http://i.imgur.com/9xI7s6a.png)
扩展卷组，将/dev/sdc物理卷添加到VolGroup卷组中

	vgextend ubuntu-vg /dev/sdc
再次查看VolGroup的情况，发现VG Size大小变了

将新的VolGroup空闲空间划入LV，数字为Free PE/Size大小

	 lvcreate -l 256 -n seafile ubuntu-vg

如果是第一次扩容请跳过下面两步，如果不是请执行下面两步：

1. 检查seafile逻辑卷

	e2fsck -f /dev/mapper/ubuntu--vg-seafile

2. 重新定义分区大小

	resize2fs /dev/mapper/ubuntu--vg-seafile

修改配置文件

	vim /etc/fstab
添加

	/dev/mapper/ubuntu--vg-seafile     /home/seafile/seafile/seafile-data   ext4 defaults  0 0
格式化seafile逻辑卷

	mkfs.ext4 /dev/mapper/ubuntu--vg-seafile
修改seafile目录权限

	chmod 777 /home/seafile/seafile
将seafile逻辑卷挂载到seafile目录下（这一步可以省略，因为在配置文件/etc/fstab中已经将seafile逻辑卷的挂载点配置好，开机或重启后可自动挂载）  
**注意：如果使用这条命令，挂载点一定要和配置文件/etc/fstab保持一致，否则下次开机后会造成数据丢失**

	mount /dev/mapper/ubuntu--vg-seafile /home/seafile/seafile/seafile-data

	