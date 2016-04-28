# Ubuntu14.04LTS搭建HTTP代理服务器 #
搭建环境

1. Ubuntu server14.04LTS
2. 板载网卡（IP：192.168.3.59，连接在局域网内）
3. 无线网卡（型号：BCM4322）
## 一、安装网卡驱动 ##
网卡驱动链接：[http://www.broadcom.com/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz](http://www.broadcom.com/docs/linux_sta/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz)
### 1、工具安装 ###
驱动程序的安装采用的是源码编译的方式，需要用到gcc编译器、make工具。

	apt-get install gcc
	apt-get install make
### 2、驱动程序编译安装 ###
将下载好的驱动程序上传至Ubuntu系统中，然后进行解压、编译、安装。

	cd /usr/local/
	tar zxvf /home/ubuntu/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz
	mv hybrid-v35_64-nodebug-pcoem-6_30_223_271 hybrid
	cd hybrid/
	make
	make install
### 3、卸载系统中相关模块 ###
Ubuntu系统中已经包含了一些BCM的驱动模块，我们需要将这些模块卸载,加入黑名单。

	lsmod | grep b43|ssb|wl
	rmmod b43
	rmmod ssb
	rmmod wl
	echo "blacklist ssb" >> /etc/modprobe.d/blacklist.conf
    echo "blacklist b43" >> /etc/modprobe.d/blacklist.conf
### 4、加载内核模块 ###
	modprobe lib80211
	modprobe cfg80211
	insmod wl.ko
	depmod -a
	modprobe wl	
### 5、修改无限网络设置 ###
网络接口的配置文件是/etc/network/interfaces,我们需要在里面配置无限网卡的信息。

	auto wlan0
	iface wlan0 inet dhcp
### 6、测试 ###
先使用 `ifconfig` 查看wlan0是否开启。若在下面的信息中没有包含 wlan0，可使用命令 `ifup wlan0` 或 `ifconfig wlan0 up` 开启。

完成上面工作后，我们可以连接无线网络进行测试。

扫描可用WiFi

	iwlist wlan0 scan
连接WiFi

	iwconfig wlan0 essid "WiFiName" -k "Password"
设置网关

	route add default gw 192.168.1.1 dev wlan0
查看是否成功连接

	iwcomnfig
执行完上面命令，在出现的wlan0后面的ESSID是有WiFi名的。

检查是否可以上网

	ping www.baidu.com
### 7、开机启动 ###
	vim /etc/rc.local
	sudo modprobe b43
	sudo ifup wlan0
	sudo route add default gw 192.168.1.1 dev wlan0
## 二、安装Squid ##
### 1、Squid ###
	apt-get install squid
### 2、修改配置文件 ###
将原有的配置文件备份后删除，创建新的配置文件，加入以下内容。

	cd /etc/squid3
	vim squid.conf
	
	acl SSL_ports port 443
	acl Safe_ports port 80          
	acl Safe_ports port 21          
	acl Safe_ports port 443         
	acl Safe_ports port 70          
	acl Safe_ports port 210         
	acl Safe_ports port 1025-65535  
	acl Safe_ports port 280         
	acl Safe_ports port 488        
	acl Safe_ports port 591         
	acl Safe_ports port 777         
	acl localnet src 192.168.1.0/24
	acl CONNECT method CONNECT
	http_port 192.168.3.59:8888			
	http_access deny !Safe_ports
	http_access deny CONNECT !SSL_ports
	http_access allow localhost manager
	http_access deny manager
	http_access allow localnet
	http_access allow localhost
	http_access allow all 			
	cache_dir ufs /var/log/squid3/cache 1024 16 256
	coredump_dir /var/spool/squid3
	refresh_pattern ^ftp:           1440    20%     10080
	refresh_pattern ^gopher:        1440    0%      1440
	refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
	refresh_pattern (Release|Packages(.gz)*)$      0       20%     2880
	refresh_pattern .               0       20%     4320
	dns_nameservers 223.5.5.5
	visible_hostname 192.168.3.59		
	cache_mgr 1176675476@qq.com   
	cache_access_log /var/log/squid3/access.log combined
### 3、启动squid ###
	squid3 -z
	squid3 -s
Squid常用命令：[http://www.blog.chinaunix.net/uid-18933439-id-2808695.html](http://www.blog.chinaunix.net/uid-18933439-id-2808695.html)
### 4、测试 ###
设置局域网内的另外一台PC使用代理服务器，地址与端口填写为Squid配置文件中配置内容。
### 5、开机自启动 ###
	vim /etc/rc.local
	sudo squid3 -s