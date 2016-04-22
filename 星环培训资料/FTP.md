#Ubunut server14.04LTS安装ProFTP1.3.6、MySQL5.7.11#
我的系统是Ubuntu server14.04LTS，在安装时只选择了OpenSSL。
我安装的ProFTP是源码安装的，在编译时需要用的MySQL的安装路径，系统自带的MySQL不是很好用，所以我就决定MySQL也用源码安装。

刚装好的系统建议分别使用 `apt-get update`和`apt-get upgrade`两条命令，把在线安装的源和系统内部源更新一下，否则在在线安装时会提示下载对应的包失败。
##一、MySQL5.7.11安装##
MySQL5.7.11安装包链接：[http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz](http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz)
### 1、卸载以前安装的MySQL或者是系统自带的###
我的系统中带的是MySQL5的版本，执行下面4条语句卸载MySQL

`sudo apt-get autoremove --purge mysql-server-5.0`

`sudo apt-get remove mysql-server`

`sudo apt-get autoremove mysql-server`

`sudo apt-get remove mysql-common`
清除卸载残留

`dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P`
### 3、解压(已经使用shell工具将压缩包放在用户目录下) ###
`cd /usr/local`

`tar zxvf /home/ubuntu/mysql-5.7.11-linux-glibc2.5-x86_64.tar.gz`

`mv mysql-5.7.11-linux-glibc2.5-x86_64 mysql`
### 4、创建MySQL用户和组 ###
添加用户组 

`groupadd mysql  `
 
添加mysql用户

`useradd -r -g mysql -s /bin/false mysql  ` 

进入到解压的目录下面

`cd mysql `

创建此文件夹

`mkdir mysql-files`

改文件夹的权限

`chmod 750 mysql-files `

**.**	此时代表的文件夹是/usr/local/mysql，改当前文件夹及子目录的所有者

`chown -R mysql .`

**.**	此时代表的文件夹是/usr/local/mysql，改当前文件夹及子目录的用户组

`chgrp -R mysql .`

执行完后，它会给你一个root的初始密码，由大写字母、小写字母、数字、符号组成，保留下来为以后登录做准备，登录后可以修改。如果在登录时输入不正确，后面有方法可以补救。还会自动生成一个data文件夹，可以执行ls命令查看是否生成。
	
`bin/mysqld --initialize --user=mysql `

开启SSL

`bin/mysql_ssl_rsa_setup` 

把当前目录的属主改回root

`chown -R root . `

修改data、mysql-files文件夹的属主

`chown -R mysql data mysql-files`

服务加到启动项的

`cp support-files/mysql.server  /etc/init.d/mysql.server`
### 5、配置配置文件 ###
修改mysql/support-files/my-default.conf

 # basedir = /usr/local/mysql

 # datadir = /usr/local/mysql/data

 # port = 3306

将修改后的文件拷贝至/etc下面，且重命名为my.cnf

`cp support-files/my-default.cnf /etc/my.cnf`

在/etc/profile文档最后配置MySQL环境变量

`export MYSQL_HOME=/usr/local/mysql`

` export PATH=$PATH:$MYSQL_HOME/bin`

使配置文件生效

`source /etc/profile`
### 6、启动MySQL ###
#### (1)将启动脚本拷贝到/etc/init.d路径下 ####
`cp support-files/mysql.server /etc/init.d/mysql`

使用下面命令开启、重启、关闭MySQL

`/etc/init.d/mysql start  (restart|stop)`
#### (2)在MySQL安装路径中 ####
`support-files/mysql.server start  (restart|stop)`
#### (3)开机自启动 ####
在/etc/rc.local文档中添加代码：

`sudo /etc/init.d/mysql start`

或：`sudo /usr/local/mysql/support-files/mysql.server start`

你执行任何命令，MySQL都会提示你以下信息：

`ERROR 1820 (HY000): You must SET PASSWORD before executing this statement`

这是因为上面生成的密码是临时的，刚进去MySQL需要先设置root的密码才能进行其他的操作。
解决方法：

`SET PASSWORD = PASSWORD('123456');`
#### 7、忘记root临时密码 ####
之前在安装的时候不是有一步会给个初始密码你么，这在以前的mysql的时候是没有初始密码的，直接回车就到数据库里面去了。
执行`bin/mysql -uroot -p`,系统提示：`ERROR 1045 (28000) : Access denied for user 'root'@'localhost' (using password : No)`

修改MySQL的配置文件（默认为/etc/my.cnf）,在[mysqld]下添加一行：`skip-grant-tables`

`service mysqld restart`后，即可直接使用	`mysql`	进入。

CentOS设置root密码：

mysql>	`update mysql.user set authentication_string=password('123456') where user='root' and Host = 'localhost';`

Ubuntu设置root密码：

mysql> 	`update user set password=PASSWORD('123456') where user='root';`

刷新权限

mysql>	`flush privileges;`

mysql>	`quit;`

将/etc/my.cnf文件还原（删除skip-grant-tables），重新启动

support-files/mysql.server restart,这个时候可以使用mysql -u root –p '123456'进入了
##安装过程中遇到的错误及解决办法  ##
### 1、当我执行mysql –uroot –p时提示我如下信息： ###
`The program 'mysql' can be found in the following packages:`

`	*mysql-client-core-5.5`

`	*mariadb-client-core-5.4`

`	*mysql-client-core-5.6`

`	*percona-xtradb-cluster-client-5.5`

`Try： agt-get install <selected package>`

可以执行下面代码：

`bin/mysql –uroot –p`

尝试过把bin下面的mysql脚本拷贝至mysql路径中，但还是提示如上信息

但是这样有点不太方便的就是每次进入MySQL都需要切换到MySQL的安装路径下，在这里再介绍个更方便的方法，就是使用别名，这样可以在任何文件夹下面都可以开启MySQL。

`vim ~/.bashrc`

`alias mysql='/usr/local/mysql/bin/mysql'`

`source ~/.bashrc`
## 二、ProFTP1.3.6安装 ##
ProFTP安装包链接：[ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6rc2.tar.gz](ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.6rc2.tar.gz)

预期效果：当在MySQL数据库中插入一个用户时，ubuntu系统也要创建该用户。/home目录下的用户文件夹就作为该用户的FTP空间。

因为系统最初什么都没有安装，所以在编译安装ProFTP前把gcc、make工具装上。

`apt-get install gcc`

`apt-get install make`

ProFTPd依赖的库

`apt-get install zlib1g-dev`
### 1、	创建用户、用户组 ###
#### a、创建proftpd服务运行的用户和用户组(数字为uid、gid，可以随意设置，但是要大于500) ####
` groupadd ftpgroup -g 3001`

`useradd ftpuser -u 3001 -g 3001 -s /usr/sbin/nologin`

`chown –R ftpuser.ftpgroup /home`
#### b、创建匿名登陆用户映射的系统用户和用户组 ####
`groupadd ftp -g 3000`

创建匿名用户访问空间

`mkdir /home/ftp`

`useradd ftp -u 3000 -g 3000 -d /home/ftp -s /usr/sbin/nologin`

`chown –R ftp.ftp /home/ftp`

`chmod 755 /home/ftp`
### 2、	编译安装 ###
#### a、	安装配置 ####
`./configure --prefix=/usr/local/proftpd --with-modules=mod_sql:mod_sql_mysql:mod_quotatab:mod_quotatab_sql --with-includes=/usr/local/mysql/include/ --with-libraries=/usr/local/mysql/lib/`

解释：

--prefix    			Proft的安装路径

--with-includes        mysql 的includes 目录 

--with-libraries        mysql 的lib 目录

--with-modules		添加 mod_sql、mod_sql_mysql 模块是为了让 ProFTP 支持通过 MySQL 数据库中的数据验证用户，添加 mod_quotatab、 mod_quotatab_sql 是为了让 ProFTP 支持磁盘限额和从MySQL数据库中读取、写入磁盘限额信息
#### b、编译安装 ####
`make`

`make install`

### 3、	修改ProFTP配置文件 ###
ProFTP的配置文件为proftpd安装路径下的etc下的proftpd.conf
以下是我的配置文件：

`ServerName              "My_Ftp_Server"`

`ServerType                 standalone`

`DeferWelcome                   off`

`DefaultServer                     on`

`ShowSymlinks                     on`

`UseReverseDNS 		off`

`AllowStoreRestart 		on`

`AllowRetrieveRestart 		on`

`UseIPv6                               off`

`DefaultRoot         ~`

`RequireValidShell           off`

`Port                             21`

`MaxInstances                    30`

`User                   ftpuser`

`Group                  ftpgroup`

`<Directory />`

`AllowOverWrite on`

`</Directory>`

`Umask                                  022`

`AllowOverwrite                           on`


`TransferLog  /var/log/proftpd/xferlog`

`SystemLog  /var/log/proftpd/proftpd.log`

`<IfModule mod_quotatab.c>`

`QuotaEngine on`

`QuotaLog /var/log/proftpd/quota.log`

`<IfModule mod_quotatab_sql.c>`

`SQLNamedQuery get-quota-limit SELECT "* FROM quotalimits WHERE 
name = '%{0}' AND quota_type = '%{1}'"`

`SQLNamedQuery get-quota-tally SELECT "* FROM quotatallies WHERE name = '%{0}' AND quota_type = '%{1}'"`

`SQLNamedQuery update-quota-tally UPDATE "bytes_in_used = bytes_in_used + %{0}, bytes_out_used = bytes_out_used + %{1}, bytes_xfer_used = bytes_xfer_used + %{2}, files_in_used = files_in_used + %{3}, files_out_used = files_out_used + %{4}, files_xfer_used = files_xfer_used + %{5} WHERE name = '%{6}' AND quota_type = '%{7}'" quotatallies`

`SQLNamedQuery insert-quota-tally INSERT "%{0}, %{1}, %{2}, %{3}, %{4}, %{5}, %{6}, %{7}" quotatallies`

`QuotaLock /var/lock/ftpd.quotatab.lock`

`QuotaLimitTable sql:/get-quota-limit`

`QuotaTallyTable sql:/get-quota-tally/update-quota-tally/insert-quota-tally`

`</IfModule>`

`</IfModule>`

`<Limit SITE_QUOTA>`

`AllowAll`

`</Limit>`

`<Anonymous ~ftp>`


`User                      ftp`

`Group                     ftp`

`UserAlias                   anonymous ftp   `

`RequireValidShell              off`

`MaxClients                         30`


`<Limit WRITE>`

`DenyAll`

`</Limit>`

`</Anonymous>`

`QuotaDirectoryTally         on`

`QuotaDisplayUnits           "Mb"`

`QuotaEngine    on`

`QuotaLog /usr/local/proftpd/var/quotaLog`

`QuotaShowQuotas on`

`SQLLogFile "/var/log/proftpd/proftpd.sql.log`    

`SQLConnectInfo	proftpd@localhost:3306 ftp 123`

`SQLAuthTypes Backend Plaintext`

`SQLUserInfo ftpusers userid passwd uid gid homedir shell`

`SQLGroupInfo ftpgroups groupname gid members`

`SQLAuthenticate users groups usersetfast groupsetfast`

具体的参数介绍可以参考以下文档：[http://os.51cto.com/art/201103/247083.htm](http://os.51cto.com/art/201103/247083.htm)
**扩展内容**

limit用法如下：

　　CMD：Change Working Directory 改变目录

　　MKD：MaKe Directory 建立目录的权限

　　RNFR： ReName FRom 更改目录名的权限

　　DELE：DELEte 删除文件的权限

　　RMD：ReMove Directory 删除目录的权限

　　RETR：RETRieve 从服务端下载到客户端的权限

　　STOR：STORe 从客户端上传到服务端的权限

　　READ：可读的权限，不包括列目录的权限，相当于RETR，STAT等

　　WRITE：写文件或者目录的权限，包括MKD和RMD

　　DIRS：是否允许列目录，相当于LIST，NLST等权限，还是比较实用的

　　ALL：所有权限

　　LOGIN：是否允许登陆的权限
　　
针对上面这个Limit所应用的对象，又包括以下范围 

　　AllowUser 针对某个用户允许的Limit

　　DenyUser 针对某个用户禁止的Limit

　　AllowGroup 针对某个用户组允许的Limit

　　DenyGroup 针对某个用户组禁止的Limit

　　AllowAll 针对所有用户组允许的Limit

　　DenyAll 针对所有用户禁止的Limit
## 三、添加用户，设置磁盘限额 ##
### 1、	创建数据库 ###
`create database proftpd;`

切换数据库

`use proftpd;`

添加连接数据库的用户，与配置文件proftpd.conf中SQLConnectInfo信息一致

`grant all privileges on proftpd.* to ftp@"localhost" identified by "123";`
### 2、	创建用户、磁盘限额表 ###
#### a、	创建用户表 ####
`CREATE TABLE ftpusers (userid TEXT NOT NULL,passwd TEXT NOT NULL,uid INT NOT NULL,gid SMALLINT NOT NULL,homedir TEXT,shell TEXT);`
#### b、	创建用户组表 ####
`CREATE TABLE ftpgroups (groupname TEXT NOT NULL,gid SMALLINT NOT NULL,members TEXT NOT NULL);`
#### c、创建磁盘限额信息表 ####
`CREATE TABLE quotalimits (`

`name VARCHAR(30),`

`quota_type ENUM("user", "group","class", "all") NOT NULL,`

`per_session ENUM("false", "true")NOT NULL,`

`limit_type ENUM("soft", "hard")NOT NULL,`


`bytes_in_avail FLOAT NOT NULL,`

`bytes_out_avail FLOAT NOT NULL,`

`bytes_xfer_avail FLOAT NOT NULL,`

`files_in_avail INT UNSIGNED NOT NULL,`

`files_out_avail INT UNSIGNED NOT NULL,`

`files_xfer_avail INT UNSIGNED NOT NULL`

`);`

**扩展内容**

quotalimits 		表中各字段的含意：

quota_type 			磁盘限额的鉴别

bytes_in_avail 		上传最大字节数，就是FTP用户空间容量

bytes_out_avail		下载最大字节数

bytes_xfer_avail 	总共可传输的文件的最大字节数(上传和下载流量)

files_in_avail 		总共能上传文件的数目

files_out_avail 	能从服务器上下载文件的总数目

files_xfer_avail   	总共可传输文件的数目(上传和下载)
#### d、	创建磁盘使用信息表 ####
`CREATE TABLE quotatallies (`

`name VARCHAR(30) NOT NULL,`

`quota_type ENUM("user", "group", "class", "all") NOT NULL,`

`bytes_in_used FLOAT NOT NULL,`

`bytes_out_used FLOAT NOT NULL,`

`bytes_xfer_used FLOAT NOT NULL,`

`files_in_used INT UNSIGNED NOT NULL,`

`files_out_used INT UNSIGNED NOT NULL,`

`files_xfer_used INT UNSIGNED NOT NULL`

`);`

该表中的内容系统会自动添加
### 3、	添加FTP用户记录 ###
#### a、	添加普通用户 ####
添加用户proftp，密码为123456，/home/proftp是用户主目录，proftp用户将在该用户访问服务器时自动创建，用户shell为空

`INSERT INTO ftpusers (userid, passwd, uid, gid,homedir, shell) `
`values ('proftp', '123456', 3002, 3001, '/home/proftp','' );`

添加用户组

`INSERT INTO ftpgroups VALUES ('ftpgroup', 3001, 'proftp');`

添加磁盘限额信息

建立初始用户磁盘限额信息，为用户proftp，最多可以上传51200000字节,即分配了大约48.83MB的空间。最多可以下载48.83MB,最多可以上传1000个文件，下载1000个文件，文件的传输流量为48.83MB，总共可以传输2000个文件。（如果不想对这些作限制，可以设置为0）

`INSERT INTO quotalimits (name,quota_type,per_session,limit_type,bytes_in_avail,
bytes_out_avail,bytes_xfer_avail,files_in_avail,files_out_avail,files_xfer_avail)
VALUES  ('http', 'user', 'false', 'hard', '51200000','51200000','51200000','1000', '1000','2000');`

在ubuntu系统中添加用户、设置密码

`useradd proftp -u 3002 -g 3001 -d /home/proftp -s /usr/sbin/nologin -m`


`passwd proftp`

为了便于管理用户，建议以后创建系统用户时UID依次递增（下一个用户可以使用3003）。
#### b、	添加匿名用户 ####
匿名用户只用添加用户组

`INSERT INTO ftpgroups VALUES ('ftp', 3000, 'ftp');`
### 4、	设置ProFTP环境变量 ###
`vim /etc/profile`

`export PROFTPD_HOME=/usr/local/proftpd`

`export PATH=$PATH:$PROFTPD_HOME/bin`

`source /etc/profile`

如果已经声明过来PATH，可以直接在PATH后面追加:$PROFTPD_HOME/bin
### 5、	运行ProFTP ###
因为配置文件中有好多日志文件的输出路径，我们需要自己创建几个文件

`mkdir /var/log/proftpd`

`touch /var/log/proftpd/proftpd.log`

proftpd的启动需要用到MySQL的一个库（libmysqlclient.so.20）,我们提前把它添加进来。

`vim /etc/ld.so.conf`

`/usr/local/mysql/lib`

使配置文件生效

`ldconfig`

在proftpd安装路径下执行：

`./proftpd`
### 6、	验证性测试 ###
a、	拷贝一些文件放在/home/ftp文件夹中，在浏览器地址栏中输入ftp://192.168.3.99（这个是FTP服务器的IP地址），会看到你拷贝的文件。

b、	在windows中打开cmd，输入`ftp 192.168.3.99`，回车后会提示输入用户名、密码,使用`quote site quota`命令，有磁盘限额信息显示。往文件夹里面拷贝文档，重新执行`quote site quota`，磁盘限额信息发生变化
### 7、添加启动脚本 ###
`vim /etc/init.d/proftpd`

脚本内容：

`#!/bin/bash`
 
`#`

 `FTPD_BIN=/usr/local/proftpd/sbin/proftpd`

 `FTPD_CONF=/usr/local/proftpd/etc/proftpd.conf`

 `PIDFILE=/usr/local/proftpd/var/proftpd.pid`

 `if [ -f $PIDFILE ]; then`

 `pid=`cat $PIDFILE`   `

 `fi`

 `if [ ! -x $FTPD_BIN ]; then`

 `echo "$0: $FTPD_BIN: cannot execute"`

 `exit 1`

 `fi`

 `case $1 in`

 `start)`

 `if [ -n "$pid" ]; then`

 `echo "$0: proftpd [PID $pid] already running"`

 `exit`

 `fi`

 `if [ -r $FTPD_CONF ]; then`

 `echo "Starting proftpd..."`

 `$FTPD_BIN -c $FTPD_CONF`

 `else`

 `echo "$0: cannot start proftpd -- $FTPD_CONF missing"`

 `fi`

 `;;`

 `stop)`

 `if [ -n "$pid" ]; then`

 `echo "Stopping proftpd..."`

 `kill -TERM $pid`

 `else`

 `echo "$0: proftpd not running"`

 `exit 1`

 `fi`

 `;;`

 `restart)`

 `if [ -n "$pid" ]; then`

 `echo "Rehashing proftpd configuration"`

 `kill -HUP $pid`

 `else`

 `echo "$0: proftpd not running"`

 `exit 1`

 `fi`

 `;;`

 `*)`

 `echo "usage: $0 {start|stop|restart}"`

 `exit 1`

 `;;`

 `esac`

 `exit 0`

给脚本设置可执行权限

`chmod +x /etc/init.d/proftpd`

以后就可以通过下面命令控制proftpd的开启与关闭

`/etc/init.d/proftpd start(stop|restart)`


