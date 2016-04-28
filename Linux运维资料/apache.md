#  Apache2.4安装配置（源码编译）
##	 安装apache2.4 
###1. 先安装c++编译相关组件:
   刚装好的Ubuntu系统中已经有GCC了，但是这个GCC什么文件都不能编译，因为没有一些必须的头文件，所以要安装build-essential这个软件包，安装了这个包会自动安装上g++,libc6-dev,linux-libc-dev,libstdc++6-4.1-dev等一些必须的软件和头文件库。
   安装所需要的软件包：

    sudo apt-get install build-essential
###2. 编译安装APR  
#### - 先下载apr:
    地址：http://mirror.esocc.com/apache/apr/
    存放位置：/usr/local/src/apr-1.5.1.tar.gz
#### - 解压
    cd /usr/local/src
    tar -zxvf apr-1.5.1.tar.gz
#### - 编译
    cd apr-1.5.1
    ./configure -prefix=/usr/local/apr
    make && make install
###3.再编译安装apr-util，类似于上一步安装apr
#### - 先下载apr-util:
     地址同apr：http://mirror.esocc.com/apache/apr/
     存放位置：/usr/local/src/apr-util-1.5.3.tar.gz
#### - 解压
     cd /usr/local/src
     tar -zxvf apr-util-1.5.3.tar.gz
#### - 编译
    cd apr-util-1.5.3
    ./configure -prefix=/usr/local/apr-util 
     --with-apr=/usr/local/apr //这里带上apr安装路径
    make && make install
###4. 再编译安装pcre
#### - 先下载pcre:
    地址：http://sourceforge.net/projects/pcre/files/pcre/
    存放位置：/usr/local/src/pcre-8.35.tar.gz
#### - 解压
    cd /usr/local/src
    tar -zxvf pcre-8.35.tar.gz
#### - 编译
    cd pcre-8.35
    ./configure -prefix=/usr/local/pcre
    make && make install
###5.安装zlib-devel两种方法
    1. apt-get install zlib1g-dev
    //用apt-get安装
    2. 源码安装zlib，步骤同上:
     下载地址：http://sourceforge.net/projects/libpng/ files/zlib/
     存放地址:/home/xxx/Downloads
    cp /home/xxx/Downloads/zlib-1.2.8.tar.gz /usr/local/src
    cd /usr/local/src
    tar -zxvf zlib-1.2.8.tar.gz
    cd zlib-1.2.8
    ./configure -prefix=/usr/local/zlib
    make && make install
##安装apache2.4
###1. 先到apache官方网站下载最新版本 
    http://httpd.apache.org/download.cgi  httpd-2.4.18.tar.gz
###2. 然后进行解压
    tar -zxvf httpd-2.4.18.tar.gz
###3. 编译
    cd /usr/local/httpd-2.4.18
    ./configure --prefix=/usr/local/apache 
     --enable-so --enable-proxy --enable-proxy-http
     --enable-proxy-balancer --enable-modules=all 
     --enable-mods-shared=all  
     --with-apr=/usr/local/apr  
     --with-pcre=/usr/local/pcre  
     --with-apr-util=/usr/local/apr-util/    
    //原编译命令

####4. 编译报错
    exports.c:1572: error: 
    redefinition of `ap_hack_apr_allocator_create' 
    exports.c:177: error:  
    `ap_hack_apr_allocator_create' previously defined here 
打开server/exports.c，查看源代码发现，在1572和177确实有两个同样的宏，而且这两个宏的开关是相同的条件，就是说无论怎么编译，这份代码是不可能编译通过的!!!!再看这两个宏上面的注释，一个是来自/usr/local/apr/include/，另外一个是来自/usr/local/apr-until/, 这时重新解压httpd的源代码，发现并没有这个源文件，于是自然就想到是configure的时候生成的这份源代码。 查看之前调用的configure命令，发现同时指定了apr和apr-until，所以最终生成了这个有问题的exports.c
######解决办法，configure httpd时不要with apr，只with pcre就足够了
######正确configure命令如下：
    ./configure --prefix=/usr/local/apache 
     --enable-so --enable-proxy --enable-proxy-http 
     --enable-proxy-balancer --enable-modules=all 
     --enable-mods-shared=all --with-pcre=/usr/local/pcre 
     --with-apr-util=/usr/local/apr-util/
####5. 编译无错时   
     make make install
#####注意：重复编译时记得 
    make clean

###6. 等安装完以后进入到安装目录，开启apache服务
    cd /usr/local/apache/bin/
    ./apachectl start
######发现报错
     AH00558: 
     httpd: Could not reliably determine the server's fully qualified domain name,
     using localhost.localdomain. Set the 'ServerName' directive globally to suppress this message
额，原来就是配置文件中没有serverName,那就在httpd.conf 中增加 ServerName
 
     vim /usr/local/apache/conf/httpd.conf
     #增加
     ServerName localhost
###7. 重启apache，浏览器如果不能显示it works！
     cd /usr/local/apache/logs
     cat erro_logs
查看错误日志，是不是有moudle没有加载，如果有，编辑httpd.conf下把对应moudle前面的注释去掉
我遇到的是: LoadModule slotmem_shm_module modules/mod_slotmem_shm.so这个没加载
个人感觉出问题多看看错误日志，这个比你在网上盲目的找更高效，包括接下来的配置……

## Apache用户访问权限控制 ##
 参考地址：http://zhangyulong2087.blog.163.com/blog/static/15026925620101064173313/

    cd  /usr/local/apache/
    cp  httpd.conf  httpd.conf.bak  //备份
###第一步：配置基本验证方式
####方法一:  配置httpd.conf 文件,在httpd.conf 文件中的配置模块代码如下：
    <Directory /usr/apache/htdocs/>
    #该模块的作用目录为/usr/apache/htdocs/。
    AuthName Protected
    #提示用户的信息为“Protected”。
    AuthType basic
    # AuthType 鉴别方法是basic。
    AuthUserFile /usr/apache/conf/users
    # 这一行很重要，它指定了验证用户名和口令的路径和文件名。
    #根据自己验证可以直接拿/etc/shadow文件来用，需要给改其权限 chmod a+r /etc/shadow
    #不推荐这样做，很不安全
    <Limit GET POST>
    # 限制HTTP 协议中的GET 和POST 方法。
       require valid-user
    # 需要合法的用户，即在/usr/apache/conf/users 文件中的用户。
    </Limit>
    </Directory>
####方法二： 使用.htaccess文件
#####注意：
1. .htaccess文件存放位置,一般放在apache自己配置的目录下面，这样服务器查找起来比较快，效率高
2. 使用这个文件没有直接配置在httpd.conf中好，一个是安全问题，另一个还是效率
#####   自己写的小例子：
    root@ubuntu:/home# cat .htaccess 
    #AuthUserFile /usr/local/apache2/conf/users
    AuthUserFile /etc/shadow    
    AuthName Protect 
    AuthType Basic 
    <limit GET POST>
      require valid-user
    </Limit>

###第二步：生成用户密码文件，命令htpasswd 可以帮助我们完成这项任务。
比如说我们想要生成lgm 用户密码文件，操作如下：

     htpasswd –c /usr/local/apache/conf/users lgm 
     new password:123456
     Re-type new password:123456
     
其中123456 是用户lgm 的验证密码。
如果想要生成多个用户，则需要使用htpasswd 命令的“-b”参数，操作如下：

    htpasswd –b /usr/local/apache/conf/users test 123456 
执行完上述的命令后，可以查看users 文件的内容，操作如下：

    cat /usr/apache/conf/users 
    #内容如下：
    lgm:bBdPD1.jOo3tQ 
    test:3PIo6y6wDBuI2 
###第三步： 测试
  重新启动Apache 服务器后，在浏览器中输入本机IP，要求输入用户名和密码才能访问。
#### Apache服务器配置多端口站点
参考文档：http://www.server110.com/apache/201309/1910.html

    vi /usr/local/apache/conf/httpd.conf  
    Listen 8000
    Listen 8001
    namevirtualhost *:8000
    <VirtualHost *:8000>
       ServerAdmin admin@127.0.0.1s
       ServerName *:8000
       DocumentRoot /usr/loacl/apache/hdocs/
    </VirtualHost>
    <Directory "/usr/loacl/apache/hdocs/">
       Options Indexes FollowSymLinks MultiViews
       AllowOverride All
       Order allow,deny
       Allow from all
    </Directory>
    namevirtualhost *:8001
    <VirtualHost *:8001>
       ServerAdmin admin@127.0.0.1s
       ServerName *:8001
       DocumentRoot /usr/www/
    </VirtualHost>
    <Directory " /usr/www/">
    Options Indexes FollowSymLinks MultiViews
       AllowOverride All
       Order allow,deny
       Allow from all
    </Directory>
访问hdocs:

    http://192.168.3.108:8000(192.168.3.108为服务器IP)
访问www：

    http://192.168.3.108:8001(192.168.3.108为服务器IP)
## Apache2.4用户~username跳转目录 
参考文档：http://pandaql.blog.51cto.com/465488/327664
####1. 编辑httpd.conf文档
     cd /usr/local/apache/conf
     vi httpd.conf
     #配置部分
     <Directory /home/>              //用户登陆验证部分
       AllowOverride all            //允许.htaccess文件内所有命令 写all时服务器会自动去找这个文件
       Options  Indexes SymLinksIfOwnerMatch  
     #<Limit GET POST>
     #  require valid-user     //验证方式，基本用户名密码方式，还可以根据所属组，网址……也可写在.htaccess文件中
     # </Limit>
     Require all granted
    # <LimitExcept GET POST OPTIONS PROPFIND>
    # Order deny,allow
    # Deny from all
    # </LimitExcept>
    </Directory>
以上配置实现的功能是，一打开apache服务器地址就会提示要求登录验证

    <IfModule mod_userdir.c>  //使用userdir模块 前面一定要加载此模块
       #UserDir disabled
       #UserDir                //这个地方以后限制root用户：UserDir disabled root 
       UserDir "/home"      //用户家目录父级目录
    <Directory /home/*>       //用通配符来匹配多个用户
       AllowOverride FileInfo AuthConfig Limit
       Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    <Limit GET POST OPTIONS>
        Order deny,allow
        Allow from all
    </Limit>
    <LimitExcept GET POST OPTIONS>
        Order deny,allow
        Deny from all
    </LimitExcept>
    </Directory>
以上配置使用了userdir这个模块，记得在配置文件前面加载此模块（去掉原来的注释）
以上结合起来实现的是登录服务器可以在服务器地址后家/~username/跳转到username目录下
还可以这样配实现可先看公共目录，在输/~username/跳转时提示先登录验证

    <Directory /home/>
        AllowOverride none
        Options  Indexes SymLinksIfOwnerMatch  
        Require all granted
    </Directory>
    <IfModule mod_userdir.c> 
        UserDir "/home"
    </IfMoudle> 
    <Directory /home/*> 
        AllowOverride none
        Options +Indexes +SymLinksIfOwnerMatch 
        AuthUserFile /etc/shadow
        AuthName Protect 
        AuthType Basic 
        <limit GET POST>
           require valid-user
        </Limit>
    </Directory> 
####3. 用户目录创建：
   创建用户（测试）

    Useradd  test
    Groupadd test
建用户目录： 

    cd /home
    mkdir test
    chmod 755 test  //在使用~username这个功能时，必须给755权限吧，我试过751，750都不行
    chown test test
    chgrp test test

浏览器调试：
     192.168.3.108/~test/
若能跳转到test目录则成功，不能跳转自己根据错误日志调
####Shell脚本自动添加用户，并创建家目录
参考文档：http://biancheng.dnbcw.info/linux/355111.html

######1. 自动添加用户，并且自动添加密码，让密码和用户名相同

例子：让系统自动添加a b c d 四个用户，并且密码和用户名同名,脚本如下：

     #!/bin/bash
     #自动添加用户和密码，且同名
     for UU in a b c d
     do
     useradd $UU
     echo $UU | passwd --stdin $UU
     done
######2. 自动添加a b c d 四个用户，并且密码都是123:

     #!/bin/bash 
     #自动添加用户和密码，且密码都是123
     for UU in a b c d
     do
     useradd $UU
     echo 123 | passwd --stdin $UU
     done
######3. 如何给已有的用户改密码？
    echo “newpassword” | passwd –stdin username
######4. 建立要添加用户列表的文件

    ee username.list
    usr1
    usr2
    usr3   //用户名用空格隔开
保存退出  
3. 写shell脚本实现自动添加用户（密码和用户名一样）

    #ee useradd.sh
    #!/bin/sh
    for USER in $(cat username.list)
    do
    mkdir /home/$USER
    echo $USER | pw useradd $USER -h 0
    HOME=/home/$USER
    done
保存退出

    chmod a+x haha.sh
    ./haha.sh
注释：echo $USER | passwd useradd $USER -h 0中的   
第一个$USER是用户密码（$USER就是usrname.list里面的内容）   
第二个$USER是用户名
#####注意：也许在你的系统里—stdin并不好用
那你可以试试chpasswd命令,写法：

    echo "root:123456" | chpasswd
如果chpasswd也不能用你还可以试试:

    passwd root  <<EOF
    123456
    123456
    EOF
以上都不好用的话也许是：   
1、分区没有空间导致。    df -i   
2、/etc/passwd 和/etc/shadow不同步 同步文件pwconv
如果遇到提示打不开/etc/passwd你可以执行以下命令:

    chattr -i  /etc/passwd
    chattr -i  /etc/shadow
最后自己写的添加用户（单个）小脚本：

    cat .htusers
    #!/bin/bash
    #add user and give he a  home
    user=$1
    pwd=$2
    chattr -i /etc/passwd
    chattr -i /etc/shadow
    # groupadd ftpusers
    useradd $user -g ftpusers
    # passwd $user
    echo $user:$pwd | chpasswd  
    mkdir /home/$user
    # HOME=/home/$user
    # chattr +i /etc/passwd
    # chattr +i /etc/shadow
    chown $user /home/$user
    chmod 755   /home/$user
执行

    ./.htusers abc 123456
即可添加


### 参考文档 
1. PHP7+Apache2.4+MySQL5.6 源码编译安装:  
    http://www.bkjia.com/Linuxjc/1096474.html
2. 安装apache编译出错解决办法：   
    http://blog.chinaunix.net/uid-12274566-id-3761679.html
3. apache+php+svn异常解决：  
    http://wxb-j2ee.iteye.com/blog/2028986
4. 删除原来版本Apache2、Php的方法：   
    http://www.51ou.com/browse/Ubuntu/59890.html
5. 关于ubuntu下安装完PHP+Apache后，无法解析php的解决方案：
    http://blog.csdn.net/renzhenhuai/article/details/14100905
6. 在ubuntu 14.04上安装php7：   
    http://www.oschina.net/question/2010961_242272
7. Ubuntu 14.04 麒麟版安装Apache+php5+mysql+phpmyadmin:
    http://my.oschina.net/tinydeng/blog/338579?fromerr=a0pA1w6q
8. Linux环境PHP7.0安装:
    http://blog.csdn.net/21aspnet/article/details/47708763