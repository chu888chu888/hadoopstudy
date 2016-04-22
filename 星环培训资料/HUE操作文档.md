#一、Hue是什么？

Hue是一个可以快速开发和调试Hadoop生态系统各种应用的一个基于浏览器的图形化接口

#二、Hue能做什么？


- 访问HDFS 和文件浏览

- 调试和开发hive以及数据结果展示

- spark开发和调试

- pig开发和调试

- 完成Oozie任务的开发，监控，和工作流协调调度

- HBase数据查询和修改，数据展示
 
- MapReduce任务进度查看，日志追踪

- 创建和提交MapReduce，Streaming，java job任务

- Zookeeper的浏览和编辑


#三、安装Hue服务


1、查看Inceptor是否开启Hive2服务，因为Hue目前只支持hive.server2服务

![](http://i.imgur.com/bz97GMP.jpg)

打开浏览器访问目标节点：8180端口

![](http://i.imgur.com/UwXodRP.jpg)

登录TDH管理页面：

![](http://i.imgur.com/9DgNXMS.jpg)

查看Inceptor的配置：

![](http://i.imgur.com/El9UU3R.jpg)

如果是hive.server2.enable配置项为false，则需要重新安装inceptor
![](http://i.imgur.com/xL22LHb.jpg)

2、停止或者删除旧的inceptor之后，重新添加inceptor服务

![](http://i.imgur.com/WX5tVXZ.jpg)

在进入配置服务步骤时，选中高级参数。将hive.server2.enable设置为TRUE。认证方式按需求定，这里选择无。之后的步骤和第一次安装inceptor相同

![](http://i.imgur.com/YqPihLF.jpg)

3、重新安装hue服务：

![](http://i.imgur.com/4ao2Hug.jpg)

选择依赖项是选择新安装的，开启hive2的inceptor服务

![](http://i.imgur.com/LGhoOlK.jpg)

之后的步骤与原来相同，不需要重新配置

4、测试hue是否可以连接inceptor

查看hue服务的配置项可以得知端口号

![](http://i.imgur.com/lR68Sth.jpg)

访问hue服务器8888端口

![](http://i.imgur.com/wyQNpnP.jpg)

之后选择query deitors  -> inceptor

![](http://i.imgur.com/Y5bviD2.jpg)

跳转页面，左边显示可供选择的数据库，以及相对应的表，则说明hue成功连接inceptor

![](http://i.imgur.com/he7O5Bf.jpg)

同时hue提供可视化的inceptor查询：
点击执行，在下方界面会跳出查询结果

![](http://i.imgur.com/sAg1ZCa.jpg)



##实例一：通过hue配置Oozie工作流


1、选择workflows编辑器
![](http://i.imgur.com/KaQeQrT.jpg)

2、点击创建，创建一个新的workflow

![](http://i.imgur.com/JtFtdeB.jpg)

![](http://i.imgur.com/P27DqJ7.jpg)

即可通过拖拽各种操作，配置Oozie工作流

简单样例工作如下

![](http://i.imgur.com/ku8uDIS.jpg)

3、创建工作流：

拖拽sqoop1到页面中间指定的位置

![](http://i.imgur.com/Di4jXpf.jpg)

弹窗：

![](http://i.imgur.com/oS59pDb.jpg)

4、输入sqoop命令：
import -connect jdbc:mysql://192.168.1.214:3306/mysql -username tdh -password 123456 -table user -target-dir /tmp/output -m 1

注意：上述sqoop命令和原生的sqoop命令有略微差别，特别是参数前面的双横杠变成了单横杠
输入完脚本后，必须点击文件，将连接mysql的jdbc驱动包添加进去

![](http://i.imgur.com/ASKX3S4.jpg)

![](http://i.imgur.com/tJkWalC.jpg)

设置就完成后点击保存，再点击执行，显示接收job任务

![](http://i.imgur.com/uJ86ziR.jpg)

这时进入8088界面，可以观察到接收到的是一个Oozie工作流的任务

![](http://i.imgur.com/z0hwxBI.jpg)

##实例二：通过hue查询Inceptor中的表的数据

![](http://i.imgur.com/T96GbxW.jpg)

定时完成workflow工作流

点击计划按钮：

![](http://i.imgur.com/ZsWnRsH.jpg)

设置频率，起止日期之后选择保存

![](http://i.imgur.com/ho7jWsy.jpg)

提交之后就可以按照设定的频率执行工作流了（定时的workflow即为一个Coordinator）
