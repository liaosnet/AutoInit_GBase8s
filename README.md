# GBase8s自动初化脚本使用说明
### 脚本名称：AutoInit_GBase8s.sh
功能：自动解压同一目录下的GBase 8s安装包，并执行数据库软件安装，数据库初始化，同时根据操作系统资源进行一定的数据库参数优化操作。最终生成可用的数据库环境。
适用性：适用于x86_64架构下的RHEL(或者类似的CentOS)操作系统环境。

### 脚本名称：AutoInit_GBase8s_Pri.sh
功能：高可用性集群主机使用，在AutoInit_GBase8s.sh的基础上增加了信任关系的创建，需要手工输入主、备机的IP地址及主机名。

### 脚本名称：AutoInit_GBase8s_Hdr.sh
功能：高可用性集群HDR备机使用，在AutoInit_GBase8s.sh的基础上增加了信任关系的创建，需要手工输入主、备机的IP地址及主机名，只创建相应的数据文件，而不进行初始化操作。

### 完成后的JDBC连接
DriverName：com.gbasedbt.jdbc.Driver
URL(直拉指定服务器)：jdbc:gbasedbt-sqli://<IPADDR>:9088/<DBNAME>:GBASEDBTSERVER=gbase01;DB_LOCALE=zh_CN.utf8;CLIENT_LOCALE=zh_CN.utf8
其中：<IPADDR>为实际IP地址，<DBNAME>为数据库名称

URL(同时连主机及HDR)：
jdbc:gbasedbt-sqli://<IPADDR>:9088 /<DBNAME>:GBASEDBTSERVER=gbase01;GBASEDBTSERVER_SECONDARY=gbase02;IFXHOST_SECONDARY=<IPADDR_HDR>;PORTNO_SECONDARY=9088;ENABLE_HDRSWITCH=true; DB_LOCALE=zh_CN.utf8;CLIENT_LOCALE=zh_CN.utf8
	其中：<IPADDR>为主机实际IP地址，<DBNAME>为数据库名称，<IPADDR_HDR>为HDR备机实际IP地址

## 使用说明：
### 1，将脚本AutoInit_GBase8s.sh与GBase 8s安装包放置同一目录下。
```text
[root@rhel6u9 auto]# ll
total 309172
-rwxr-xr-x 1 root root     10505 Feb 19 22:55 AutoInit_GBase8s.sh
-rwxr-xr-x 1 root root       348 Feb  1 15:31 CleanAll.sh
-rw-r--r-- 1 root root 316569600 Feb 18 22:45 GBase8sV8.8_TL_2.0.1A2_2_RHEL6_x86_64.tar
```
### 2，执行安装
```text
[root@rhel6u9 auto]# ./AutoInit_GBase8s.sh
[2019-02-25 22:34:48] Datadir: /bigdata/gbase
[2019-02-25 22:34:48] IPADDR: 192.168.80.163
[2019-02-25 22:34:48] Creating group [gbasedbt] and user [gbasedbt].
[2019-02-25 22:34:49] Unziping [GBase8sV8.8_TL_2.0.1A2_2_RHEL6_x86_64.tar].
```
说明：不带参数将使用默认的DATADIR=/bigdata/gbase，该目录用于存放数据库空间文件。或者实际不使用该目录，应加参数指定，如： AutoInit_GBase8s.sh  /gbasedata/dbs 指定使用的空间为/gbasedata/dbs。
注：指定的目录应有足够的空间，不少于100G。
安装过程中将打印安装过程，日志如下：
```text
[root@rhel6u9 auto]# ./AutoInit_GBase8s.sh
[2019-02-25 22:34:48] Datadir: /bigdata/gbase
[2019-02-25 22:34:48] IPADDR: 192.168.80.163
[2019-02-25 22:34:48] Creating group [gbasedbt] and user [gbasedbt].
[2019-02-25 22:34:49] Unziping [GBase8sV8.8_TL_2.0.1A2_2_RHEL6_x86_64.tar].
[2019-02-25 22:34:51] Execute software install, this will take a moment.
[2019-02-25 22:36:01] Building ~gbasedbt/.bash_profile .
[2019-02-25 22:36:01] Building /opt/gbasedbt/etc/sqlhosts .
[2019-02-25 22:36:01] Building /opt/gbasedbt/etc/onconfig.gbase01 .
[2019-02-25 22:36:01] Creating DATADIR: /bigdata/gbase .
[2019-02-25 22:36:01] Start run database init: oninit -ivy
Your evaluation license will expire on 2020-02-25 00:00:00
Reading configuration file '/opt/gbasedbt/etc/onconfig.gbase01'...succeeded
Creating /GBASEDBTTMP/.infxdirs...succeeded
Allocating and attaching to shared memory...succeeded
Creating resident pool 4310 kbytes...succeeded
Creating infos file "/opt/gbasedbt/etc/.infos.gbase01"...succeeded
Linking conf file "/opt/gbasedbt/etc/.conf.gbase01"...succeeded
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
[2019-02-25 22:36:10] Creating system database.........
[2019-02-25 22:36:36] Creating dbspace plogdbs.
[2019-02-25 22:36:36] Creating dbspace llogdbs.
[2019-02-25 22:36:38] Creating dbspace tempdbs1
[2019-02-25 22:36:39] Creating smart blob space sbspace1
[2019-02-25 22:36:39] Creating dbspace datadbs1
[2019-02-25 22:38:04] Changing auto extend able on for chunk datadbs1
[2019-02-25 22:38:06] Creating default user for mapping user
[2019-02-25 22:38:07] Moving physical log to plogdbs.
[2019-02-25 22:38:17] Adding 10 logical log file in llogdbs.
[2019-02-25 22:38:40] Moving CURRENT logical log to new logical file.
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
[2019-02-25 22:38:52] Droping logical log file which in rootdbs.
[2019-02-25 22:38:52] Creating file $INSTALL_DIR/etc/sysadmin/stop .
[2019-02-25 22:38:52] Optimizing database config.
[2019-02-25 22:38:52] Restart GBase 8s Database Server.
Your evaluation license will expire on 2020-02-25 00:00:00
Your evaluation license will expire on 2020-02-25 00:00:00
Reading configuration file '/opt/gbasedbt/etc/onconfig.gbase01'...succeeded
Creating /GBASEDBTTMP/.infxdirs...succeeded
Allocating and attaching to shared memory...succeeded
Creating resident pool 279630 kbytes...succeeded
Creating infos file "/opt/gbasedbt/etc/.infos.gbase01"...succeeded
Linking conf file "/opt/gbasedbt/etc/.conf.gbase01"...succeeded
Initializing rhead structure...rhlock_t 262144 (8192K)... rlock_t (265625K)... Writing to infos file...succeeded
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
[2019-02-25 22:39:02] Finish.
```
创建的数据库状态如下：
```text
[gbasedbt@rhel6u9 ~]$ onstat -d
Your evaluation license will expire on 2020-02-25 00:00:00

GBase Database Server Version 12.10.FC4G1TL -- On-Line -- Up 00:03:09 -- 8062872 Kbytes

Dbspaces
address          number   flags      fchunk   nchunks  pgsize   flags    owner    name
58dad028         1        0x70001    1        1        2048     N  BA    gbasedbt rootdbs
6b472dc8         2        0x70001    2        1        2048     N  BA    gbasedbt plogdbs
6b9e9028         3        0x60001    3        1        2048     N  BA    gbasedbt llogdbs
6b9e9258         4        0x42001    4        1        16384    N TBA    gbasedbt tempdbs1
6b9e9488         5        0x68001    5        1        2048     N SBA    gbasedbt sbspace1
6b9e96b8         6        0x60001    6        1        16384    N  BA    gbasedbt datadbs1
 6 active, 2047 maximum

Chunks
address          chunk/dbs     offset     size       free       bpages     flags pathname
58dad258         1      1      0          512000     501659                PO-B-- /bigdata/gbase/rootdbs
6b9eb028         2      2      0          1024000    23947                 PO-B-- /bigdata/gbase/plogdbs
6b9ec028         3      3      0          2048000    47947                 PO-B-- /bigdata/gbase/llogdbs
6b9ed028         4      4      0          256000     255947                PO-B-- /bigdata/gbase/tempdbs1
6b9f3028         5      5      0          2048000    1910085    1910085    POSB-- /bigdata/gbase/sbspace1
                                 Metadata 137862     102586     137862
6b9f4028         6      6      0          650000     649947                PO-BE- /bigdata/gbase/datadbs1
 6 active, 32766 maximum

NOTE: The values in the "size" and "free" columns for DBspace chunks are
      displayed in terms of "pgsize" of the DBspace to which they belong.

Expanded chunk capacity mode: always

[gbasedbt@rhel6u9 ~]$ onstat -g seg
Your evaluation license will expire on 2020-02-25 00:00:00

GBase Database Server Version 12.10.FC4G1TL -- On-Line -- Up 00:04:20 -- 8062872 Kbytes

Segment Summary:
id         key        addr             size             ovhd     class blkused  blkfree
425987     52564801   44000000         290177024        3833912  R     70844    0
458756     52564802   554bc000         4194304000       49153848 V     93351    930649
491525     52564803   14f4bc000        452349952        1        B     110437   0
524294     52564804   16a421000        3319549952       1        B     810437   0
Total:     -          -                8256380928       -        -     1085069  930649

   (* segment locked in memory)
No reserve memory is allocated

[gbasedbt@rhel6u9 ~]$ onstat -g ntt
Your evaluation license will expire on 2020-02-25 00:00:00

GBase Database Server Version 12.10.FC4G1TL -- On-Line -- Up 00:05:20 -- 8062872 Kbytes

global network information:
  #netscb connects         read        write    q-free  q-limits  q-exceed alloc/max
   3/   3        0            0            0    0/   0  380/  10    0/   0    0/  -1

Individual thread network information (times):
          netscb thread name    sid     open     read    write address
        5fa346f0 soctcplst        4 22:54:22                   192.168.80.163|9088|soctcp
        5f2316f0 soctcppoll       3 22:54:22
        5ea2e928 soctcppoll       2 22:54:22
```
