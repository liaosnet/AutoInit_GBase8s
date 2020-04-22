# GBase8s自动初化脚本使用说明
### 脚本名称：AutoInit_GBase8s.sh
功能：自动解压同一目录下的GBase 8s安装包，并执行数据库软件安装，数据库初始化，同时根据操作系统资源进行一定的数据库参数优化操作。最终生成可用的数据库环境。  
适用性：适用于x86_64架构下的RHEL6(或者类似的CentOS)操作系统环境。  

### 完成后的JDBC连接
DriverName：com.gbasedbt.jdbc.Driver  
URL(直接指定服务器)：jdbc:gbasedbt-sqli://<IPADDR>:9088/<DBNAME>:GBASEDBTSERVER=gbase01;DB_LOCALE=zh_CN.utf8;CLIENT_LOCALE=zh_CN.utf8;IFX_LOCK_MODE_WAIT=10;IFX_ISOLATION_LEVEL=5;  
其中：<IPADDR>为实际IP地址，<DBNAME>为数据库名称  

## 使用说明：
### 1，将脚本AutoInit_GBase8s.sh与GBase 8s安装包放置同一目录下。
```text
[root@bd ~]# ll
total 309172
-rwxr-xr-x 1 root root     14130 Apr 22 15:58 AutoInit_GBase8s.sh
-rwxr-xr-x 1 root root       921 Apr 22 15:38 CleanAll.sh
-rw-r--r-- 1 root root 316641280 Apr 22 14:57 GBase8sV8.8_AEE_2.0.1A2_2_RHEL6_x86_64.tar
```
### 2，执行安装
```text
[root@bd ~]# bash AutoInit_GBase8s.sh
[2020-04-22 15:44:40] ifconfig check passed.
[2020-04-22 15:44:40] unzip check passed.
[2020-04-22 15:44:40] tar check passed.
[2020-04-22 15:44:40] timeout check passed.
[2020-04-22 15:44:40] IPADDR: 192.168.0.4
[2020-04-22 15:44:40] Datadir: /data/gbase
[2020-04-22 15:44:40] Creating group [gbasedbt] and user [gbasedbt] with HOME [/home/gbase].
[2020-04-22 15:44:40] Unziping [GBase8sV8.8_AEE_2.0.1A2_2_RHEL6_x86_64.tar].
[2020-04-22 15:44:44] Check path INSTALL_DIR(/opt/gbase) security.
[2020-04-22 15:44:44] Execute software install, this will take a moment.
```
说明：不带参数将使用默认的DATADIR=/data/gbase，该目录用于存放数据库空间文件。或者实际不使用该目录，应加参数指定，如： AutoInit_GBase8s.sh -d /gbasedata/dbs 指定使用的空间为/gbasedata/dbs。  
注：指定的目录应有足够的空间，不少于100G。  
安装过程中将打印安装过程，日志如下：
```text
[root@bd ~]# bash AutoInit_GBase8s.sh
[2020-04-22 15:44:40] ifconfig check passed.
[2020-04-22 15:44:40] unzip check passed.
[2020-04-22 15:44:40] tar check passed.
[2020-04-22 15:44:40] timeout check passed.
[2020-04-22 15:44:40] IPADDR: 192.168.0.4
[2020-04-22 15:44:40] Datadir: /data/gbase
[2020-04-22 15:44:40] Creating group [gbasedbt] and user [gbasedbt] with HOME [/home/gbase].
[2020-04-22 15:44:40] Unziping [GBase8sV8.8_AEE_2.0.1A2_2_RHEL6_x86_64.tar].
[2020-04-22 15:44:44] Check path INSTALL_DIR(/opt/gbase) security.
[2020-04-22 15:44:44] Execute software install, this will take a moment.
[2020-04-22 15:46:37] Building ~gbasedbt/.bash_profile .
[2020-04-22 15:46:37] Building /opt/gbase/etc/sqlhosts .
[2020-04-22 15:46:37] Building /opt/gbase/etc/onconfig.gbase01 .
[2020-04-22 15:46:37] Creating DATADIR: /data/gbase .
[2020-04-22 15:46:37] Start run database init: oninit -ivy
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
[2020-04-22 15:46:54] Creating system database.......
[2020-04-22 15:47:13] Creating dbspace plogdbs.
[2020-04-22 15:47:21] Creating dbspace llogdbs.
[2020-04-22 15:47:29] Creating dbspace tempdbs01
[2020-04-22 15:47:37] Creating smart blob space sbspace01
[2020-04-22 15:47:45] Creating dbspace datadbs01
[2020-04-22 15:47:53] Changing auto extend able on for chunk datadbs01
[2020-04-22 15:47:53] Creating default user for mapping user
[2020-04-22 15:47:54] Moving physical log to plogdbs.
[2020-04-22 15:48:05] Adding 10 logical log file in llogdbs.
[2020-04-22 15:48:16] Moving CURRENT logical log to new logical file.
[2020-04-22 15:48:29] Droping logical log file which in rootdbs.
[2020-04-22 15:48:30] Creating file $INSTALL_DIR/etc/sysadmin/stop .
[2020-04-22 15:48:30] Optimizing database config.
[2020-04-22 15:48:30] Restart GBase 8s Database Server.
Reading configuration file '/opt/gbase/etc/onconfig.gbase01'...succeeded
Creating /GBASEDBTTMP/.infxdirs...succeeded
Allocating and attaching to shared memory...succeeded
Creating resident pool 13478 kbytes...succeeded
Creating infos file "/opt/gbase/etc/.infos.gbase01"...succeeded
Linking conf file "/opt/gbase/etc/.conf.gbase01"...succeeded
Initializing rhead structure...rhlock_t 32768 (1024K)... rlock_t (6640K)... Writing to infos file...succeeded
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
[2020-04-22 15:48:49] Create database testdb.
[2020-04-22 15:48:50] Finish.
```
创建的数据库状态如下：
```text
[root@bd ~]# su - gbasedbt
[gbasedbt@bd ~]$ onstat -d
GBase Database Server Version 12.10.FC4G1AEE -- On-Line -- Up 00:01:07 -- 508696 Kbytes

Dbspaces
address          number   flags      fchunk   nchunks  pgsize   flags    owner    name
45d39028         1        0x70001    1        1        2048     N  BA    gbasedbt rootdbs
58537dc8         2        0x70001    2        1        2048     N  BA    gbasedbt plogdbs
586c3028         3        0x60001    3        1        2048     N  BA    gbasedbt llogdbs
586c3258         4        0x42001    4        1        2048     N TBA    gbasedbt tempdbs01
586c3488         5        0x68001    5        1        2048     N SBA    gbasedbt sbspace01
586c36b8         6        0x60001    6        1        2048     N  BA    gbasedbt datadbs01
 6 active, 2047 maximum

Chunks
address          chunk/dbs     offset     size       free       bpages     flags pathname
45d39258         1      1      0          512000     501667                PO-B-D /data/gbase/rootchk
586c4028         2      2      0          512000     11947                 PO-B-D /data/gbase/plogchk
586c5028         3      3      0          512000     11947                 PO-B-D /data/gbase/llogchk
586c6028         4      4      0          512000     511947                PO-B-- /data/gbase/tempchk01
586c7028         5      5      0          512000     477465     477465     POSB-D /data/gbase/sbspace01
                                 Metadata 34482      25659      34482
586c8028         6      6      0          512000     511947                PO-BED /data/gbase/datachk01
 6 active, 32766 maximum

NOTE: The values in the "size" and "free" columns for DBspace chunks are
      displayed in terms of "pgsize" of the DBspace to which they belong.


Expanded chunk capacity mode: always
[gbasedbt@bd ~]$ onstat -g seg

GBase 8s Database Server Version 12.10.FC4G1AEE -- On-Line -- Up 00:04:19 -- 508696 Kbytes

Segment Summary:
id         key        addr             size             ovhd     class blkused  blkfree
1409038    52564801   44000000         77389824         1340216  R     18894    0
1441807    52564802   489ce000         524288000        6145704  V     75621    52379
1474576    52564803   67dce000         1125236736       1        B     274716   0
Total:     -          -                1726914560       -        -     369231   52379

   (* segment locked in memory)
No reserve memory is allocated

[gbasedbt@bd ~]$ onstat -g ntt

GBase 8s Database Server Version 12.10.FC4G1AEE -- On-Line -- Up 00:04:21 -- 508696 Kbytes

global network information:
  #netscb connects         read        write    q-free  q-limits  q-exceed alloc/max
   3/   3        0            0            0    0/   0  380/ 100    0/   0    0/  -1

Individual thread network information (times):
          netscb thread name    sid     open     read    write address
        4f5c7978 soctcplst        4 06:47:03                   192.168.0.4|9088|soctcp
        4fdca620 soctcppoll       3 06:47:03
```
