# GBase8s自动初化脚本使用说明
### 脚本名称：AutoInit_GBase8s.sh
功能：自动解压同一目录下的GBase 8s安装包，并执行数据库软件安装，数据库初始化，同时根据操作系统资源进行一定的数据库参数优化操作。最终生成可用的数据库环境。  
适用性：适用于x86_64架构下的RHEL6(或者类似的CentOS)操作系统环境。  

### 完成后的JDBC连接
DriverName：  
gbasedbt: com.gbasedbt.jdbc.Driver  
informix: com.informix.jdbc.IfxDriver  
jdbc:<USERNAME>-sqli://<IPADDR>:9088/<DBNAME>:<USERNAME_UPPER>SERVER=gbase01;DB_LOCALE=zh_CN.utf8;CLIENT_LOCALE=zh_CN.utf8;IFX_LOCK_MODE_WAIT=10;IFX_ISOLATION_LEVEL=5;  
其中：<IPADDR>为实际IP地址，<DBNAME>为数据库名称，<USERNAME>为gbasedbt或者informix  
用户名称：<USERNAME>  
用户密码：GBase123  

## 使用说明：
### 1，将脚本AutoInit_GBase8s.sh与GBase 8s安装包放置同一目录下。
```text
[root@a02~]# ll
total 309172
-rwxr-xr-x 1 root root     15388 12月  9 16:18 AutoInit_GBase8s.sh
-rwxr-xr-x 1 root root      1259 12月  9 16:22 CleanAll.sh
-rw-r--r-- 1 root root 316221440 9月   4 09:12 GBase8sV8.7_3.0.0_1_93e040_RHEL6_x86_64.tar
```
### 2，执行安装
```text
[root@a02 ~]# bash AutoInit_GBase8s.sh
[2020-12-13 12:27:41] The SYSDBA user is: gbasedbt
[2020-12-13 12:27:41] ifconfig check passed.
[2020-12-13 12:27:41] unzip check passed.
[2020-12-13 12:27:41] tar check passed.
[2020-12-13 12:27:41] timeout check passed.
[2020-12-13 12:27:41] IPADDR: 0.0.0.0
[2020-12-13 12:27:41] Datadir: /data/gbase
[2020-12-13 12:27:41] Creating group [gbasedbt] and user [gbasedbt] with HOME [/home/gbase].
[2020-12-13 12:27:41] Unziping [GBase8sV8.7_3.0.0_1_93e040_RHEL6_x86_64.tar].
[2020-12-13 12:27:47] Check path INSTALL_DIR(/opt/gbase) security.
[2020-12-13 12:27:47] Execute software install, this will take a moment.
```
说明：不带参数将使用默认的DATADIR=/data/gbase，该目录用于存放数据库空间文件。或者实际不使用该目录，应加参数指定，如： AutoInit_GBase8s.sh -d /gbasedata/dbs 指定使用的空间为/gbasedata/dbs。  
注：指定的目录应有足够的空间，不少于100G。  
安装过程中将打印安装过程，日志如下：  
```text
[root@bd ~]# bash AutoInit_GBase8s.sh
[2020-12-13 12:27:41] The SYSDBA user is: gbasedbt
[2020-12-13 12:27:41] ifconfig check passed.
[2020-12-13 12:27:41] unzip check passed.
[2020-12-13 12:27:41] tar check passed.
[2020-12-13 12:27:41] timeout check passed.
[2020-12-13 12:27:41] IPADDR: 0.0.0.0
[2020-12-13 12:27:41] Datadir: /data/gbase
[2020-12-13 12:27:41] Creating group [gbasedbt] and user [gbasedbt] with HOME [/home/gbase].
[2020-12-13 12:27:41] Unziping [GBase8sV8.7_3.0.0_1_93e040_RHEL6_x86_64.tar].
[2020-12-13 12:27:47] Check path INSTALL_DIR(/opt/gbase) security.
[2020-12-13 12:27:47] Execute software install, this will take a moment.
[2020-12-13 12:29:14] Building ~gbasedbt/.bash_profile .
[2020-12-13 12:29:14] Building /opt/gbase/etc/sqlhosts .
[2020-12-13 12:29:14] Building /opt/gbase/etc/onconfig.gbase01 .
[2020-12-13 12:29:14] Creating DATADIR: /data/gbase .
[2020-12-13 12:29:14] Start run database init: oninit -ivy
Reading configuration file '/opt/gbase/etc/onconfig.gbase01'...succeeded
Creating /GBASEDBTTMP/.infxdirs...succeeded
Allocating and attaching to shared memory...succeeded
Creating resident pool 4310 kbytes...succeeded
Creating infos file "/opt/gbase/etc/.infos.gbase01"...succeeded
Linking conf file "/opt/gbase/etc/.conf.gbase01"...succeeded
Initializing rhead structure...rhlock_t 16384 (512K)... rlock_t (2656K)... Writing to infos file...succeeded
Initialization of Encryption...succeeded
Initializing ASF...succeeded
Initializing Dictionary Cache and SPL Routine Cache...succeeded
Bringing up ADM VP...succeeded
Creating VP classes...succeeded
Forking main_loop thread...succeeded
Initializing DR structures...succeeded
Forking 1 'soctcp' listener threads...succeeded
Starting tracing...succeeded
Initializing 8 flushers...succeeded
Initializing log/checkpoint information...succeeded
Initializing dbspaces...succeeded
Opening primary chunks...succeeded
Validating chunks...succeeded
Creating database partition...succeeded
Initialize Async Log Flusher...succeeded
Starting B-tree Scanner...succeeded
Init ReadAhead Daemon...succeeded
Init DB Util Daemon...succeeded
Initializing DBSPACETEMP list...succeeded
Init Auto Tuning Daemon...succeeded
Checking database partition index...succeeded
Initializing dataskip structure...succeeded
Checking for temporary tables to drop...succeeded
Updating Global Row Counter...succeeded
Forking onmode_mon thread...succeeded
Creating periodic thread...succeeded
Creating periodic thread...succeeded
Starting scheduling system...succeeded
Verbose output complete: mode = 5
OK
[2020-12-13 12:29:22] Creating system database.......
[2020-12-13 12:29:41] Creating dbspace plogdbs.
[2020-12-13 12:29:43] Creating dbspace llogdbs.
[2020-12-13 12:29:44] Creating dbspace tempdbs01
[2020-12-13 12:29:47] Creating smart blob space sbspace01
[2020-12-13 12:29:50] Creating dbspace datadbs01
[2020-12-13 12:29:53] Changing auto extend able on for chunk datadbs01
[2020-12-13 12:29:53] Creating default user for mapping user
[2020-12-13 12:29:53] Moving physical log to plogdbs.
[2020-12-13 12:29:57] Adding 10 logical log file in llogdbs.
[2020-12-13 12:30:01] Moving CURRENT logical log to new logical file.
[2020-12-13 12:30:13] Droping logical log file which in rootdbs.
[2020-12-13 12:30:14] Creating file $INSTALL_DIR/etc/sysadmin/stop .
[2020-12-13 12:30:14] Optimizing database config.
[2020-12-13 12:30:14] Restart GBase 8s Database Server.
Reading configuration file '/opt/gbase/etc/onconfig.gbase01'...succeeded
Creating /GBASEDBTTMP/.infxdirs...succeeded
Allocating and attaching to shared memory...succeeded
Creating resident pool 34422 kbytes...succeeded
Creating infos file "/opt/gbase/etc/.infos.gbase01"...succeeded
Linking conf file "/opt/gbase/etc/.conf.gbase01"...succeeded
Initializing rhead structure...rhlock_t 65536 (2048K)... rlock_t (26562K)... Writing to infos file...succeeded
Initialization of Encryption...succeeded
Initializing ASF...succeeded
Initializing Dictionary Cache and SPL Routine Cache...succeeded
Bringing up ADM VP...succeeded
Creating VP classes...succeeded
Forking main_loop thread...succeeded
Initializing DR structures...succeeded
Forking 1 'soctcp' listener threads...succeeded
Starting tracing...succeeded
Initializing 32 flushers...succeeded
Initializing SDS Server network connections...succeeded
Initializing log/checkpoint information...succeeded
Initializing dbspaces...succeeded
Opening primary chunks...succeeded
Validating chunks...succeeded
Initialize Async Log Flusher...succeeded
Starting B-tree Scanner...succeeded
Init ReadAhead Daemon...succeeded
Init DB Util Daemon...succeeded
Initializing DBSPACETEMP list...succeeded
Init Auto Tuning Daemon...succeeded
Checking database partition index...succeeded
Initializing dataskip structure...succeeded
Checking for temporary tables to drop...succeeded
Updating Global Row Counter...succeeded
Forking onmode_mon thread...succeeded
Creating periodic thread...succeeded
Creating periodic thread...succeeded
Starting scheduling system...succeeded
Verbose output complete: mode = 5
[2020-12-13 12:30:34] Create database testdb.
[2020-12-13 12:30:35] Finish.

--== GBase 8s Information for this install ==--
$GBASEDBTSERVER : gbase01
$GBASEDBTDIR    : /opt/gbase
USER HOME       : /home/gbase
DBSPACE DIR     : /data/gbase
IP ADDRESS      : 192.168.80.106 127.0.0.1 
PORT NUMBER     : 9088
$DB_LOCALE      : zh_CN.utf8
$CLIENT_LOCALE  : zh_CN.utf8
JDBC URL        : jdbc:gbasedbt-sqli://IPADDR:9088/testdb:GBASEDBTSERVER=gbase01;DB_LOCALE=zh_CN.utf8;CLIENT_LOCALE=zh_CN.utf8;IFX_LOCK_MODE_WAIT=10
JDBC USERNAME   : gbasedbt
JDBC PASSWORD   : GBase123
```
创建的数据库状态如下：  
```text
[root@a02 ~]# su - gbasedbt
[gbasedbt@a02 ~]$ onstat -d
GBase Database Server Version 12.10.FC4G1AEE -- On-Line -- Up 00:06:14 -- 3366312 Kbytes

Dbspaces
address          number   flags      fchunk   nchunks  pgsize   flags    owner    name
4e3a0028         1        0x70001    1        1        2048     N  BA    gbasedbt rootdbs
60acfdc8         2        0x70001    2        1        2048     N  BA    gbasedbt plogdbs
610c7028         3        0x60001    3        1        2048     N  BA    gbasedbt llogdbs
610c7258         4        0x42001    4        1        2048     N TBA    gbasedbt tempdbs01
610c7488         5        0x68001    5        1        2048     N SBA    gbasedbt sbspace01
610c76b8         6        0x60001    6        1        2048     N  BA    gbasedbt datadbs01
 6 active, 2047 maximum

Chunks
address          chunk/dbs     offset     size       free       bpages     flags pathname
4e3a0258         1      1      0          512000     501675                PO-B-D /data/gbase/rootchk
610c8028         2      2      0          512000     11947                 PO-B-D /data/gbase/plogchk
610c9028         3      3      0          512000     11947                 PO-B-D /data/gbase/llogchk
610ca028         4      4      0          512000     511947                PO-B-- /data/gbase/tempchk01
610cb028         5      5      0          512000     477465     477465     POSB-D /data/gbase/sbspace01
                                 Metadata 34482      25659      34482
610cc028         6      6      0          512000     510041                PO-BED /data/gbase/datachk01
 6 active, 32766 maximum

NOTE: The values in the "size" and "free" columns for DBspace chunks are
      displayed in terms of "pgsize" of the DBspace to which they belong.


Expanded chunk capacity mode: always 
[gbasedbt@bd ~]$ onstat -g seg

GBase Database Server Version 12.10.FC4G1AEE -- On-Line -- Up 00:06:58 -- 3366312 Kbytes

Segment Summary:
id         key        addr             size             ovhd     class blkused  blkfree
34         52564801   44000000         148320256        2171480  R     36211    0
35         52564802   4cd73000         1048576000       12289752 V     84869    171131
36         52564803   8b573000         2250207232       1        B     549367   0
Total:     -          -                3447103488       -        -     670447   171131

   (* segment locked in memory)
No reserve memory is allocated

[gbasedbt@bd ~]$ onstat -g ntt

GBase Database Server Version 12.10.FC4G1AEE -- On-Line -- Up 00:07:24 -- 3366312 Kbytes

global network information:
  #netscb connects         read        write    q-free  q-limits  q-exceed alloc/max
   2/   3        1           13           13    1/   1  240/  10    0/   0    1/   1

Individual thread network information (times):
          netscb thread name    sid     open     read    write address
        4f1dcbe0 soctcplst        3 21:09:21 21:09:26          0.0.0.0|9088|soctcp
        4f1debe0 soctcppoll       2 21:09:27
```

### 脚本参数说明
```text
Usage:
    AutoInit_GBase8s.sh [-d path] [-i path] [-p path] [-s y|n] [-l locale] [-u user] [-o y|n]

        -d path    The path of dbspace.
        -i path    The path of install software.
        -p path    The path of home path.
        -s y|n     Value of dbspace is 1GB? Yes/No, default is Y.
        -u user    The user name for SYSDBA, gbasedbt/informix, default is gbasedbt
        -l locale  DB_LOCALE/CLIENT_LOCALE value.
        -o y|n     Only install software? Yes/No, default is N.

```
-d	指定数据库空间目录，默认为/data/gbase（若该目录非空，则使用INSTALL_DIR/data）  
-i	指定数据库软件安装目录INSTALL_DIR，默认为/opt/gbase  
-p	指定数据库用户gbasedbt的HOME目录，默认为/home/gbase  
-s	数据库空间是否均使用1GB，默认是y（所有数据库空间均使用1GB大小）  
-u  指定数据库系统管理员的名称，仅限gbasedbt和informix  
-l	指定数据库的DB_LOCALE/CLIENT_LOCALE参数值，默认为zh_CN.utf8  
-o  指定仅安装数据库，而不进行初始化操作，默认是n（安装并初始化数据库）  
