#!/bin/sh
##################################################################
# Filename: AutoInit_GBase8s.sh
# Function: Auto install GBase 8s software and auto init database.
# Write by: liaojinqing@gbase.cn
##################################################################
##### Defind env
export LANG=C
loginfo(){
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

DATADIR=${1:-/bigdata/gbase}
loginfo "Datadir: $DATADIR"

USER_NAME=gbasedbt
USER_HOME=/home/${USER_NAME:-gbasedbt}
USER_PASS=GBase123
INSTALL_DIR=/opt/${USER_NAME:-gbasedbt}
GBASESERVER=gbase01
GBASELOCALE=zh_CN.utf8
PORTNO=9088
# IP use first IPADDR
IPADDR=$(ifconfig -a | awk '/inet /{print (split($2,a,":")>1)?a[2]:$2;exit}')
loginfo "IPADDR: ${IPADDR:-127.0.0.1}"

WORKDIR=$(pwd)
### dbspace init size.
ROOTSIZE=1024000
PLOGSIZE=2048000
LLOGSIZE=4096000
SBSPACESIZE=4096000
TEMPSIZE=4096000
DATASIZE=10400000

##### Check env
if [ ! x"$(whoami)" = "xroot" ]; then
  echo "Must run as user: root"
  exit 1
fi 

SOFTPACKNAME=$(ls GBase*.tar 2>/dev/null)
if [ x"$SOFTPACKNAME" = x ]; then
  echo "Software not exists."
  exit 1
fi

if [ -x "/bin/unzip" -o -x "/usr/bin/unzip" ]; then
  printf "";
else
  echo "GBase 8s software install need: unzip"
  exit 2
fi
if [ -x "/bin/tar" -o -x "/usr/bin/tar" ]; then
  printf "";
else
  echo "GBase 8s software install need: tar"
  exit 2
fi
if [ -x "/bin/timeout" -o -x "/usr/bin/timeout" ]; then
  printf "";
else
  echo "This Auto Init Shell need: timeout"
  exit 2
fi

##### Get env
NUMCPU=$(awk '/^processor/{i++}END{printf("%d\n",i)}' /proc/cpuinfo)
NUMMEM=$(awk '/^MemTotal:/{printf("%d\n",$2/1000)}' /proc/meminfo)

if [ $NUMCPU -eq 0 ]; then
  echo "Get cpu information error."
  exit 2 
elif [ $NUMCPU -le 4 ]; then
  CPUVP=$NUMCPU
  CFG_NETPOOL=2
else
  CPUVP=$(expr $NUMCPU - 1)
  CFG_NETPOOL=$(expr $NUMCPU / 3)
fi

if [ $NUMMEM -eq 0 ]; then
  echo "Get mem information error."
  exit 2
elif [ $NUMMEM -le 8192 ]; then
  # mem less then 8G, use direct_io, only 2k buffpool
  PAGESIZE="-k 2"
  CFG_DIRECT_IO=1
  MUTI=$(expr $NUMMEM / 2000)
  [ $MUTI -eq 0 ] && MUTI=1
  CFG_LOCKS=$(expr ${MUTI:-1} \* 500000)
  CFG_SHMVIRTSIZE=$(expr ${MUTI:-1} \* 512000)
  CFG_2KPOOL=$(expr ${MUTI:-1} \* 500000)
else
  # mem big then 8G, not use direct_io, use 2k & 16k buffpool
  PAGESIZE="-k 16"
  CFG_DIRECT_IO=0
  CFG_LOCKS=2000000
  CFG_SHMVIRTSIZE=4096000
  CFG_2KPOOL=200000
  CFG_16KPOOL=200000  
fi

CFG_SHMADD=$(expr ${CFG_SHMVIRTSIZE:-1024000} / 4)
CFG_SHMTOTAL=$(expr $NUMMEM \* 900)

##### Create group and user
loginfo "Creating group [${USER_NAME}] and user [${USER_NAME}]."
groupadd ${USER_NAME} 2>/dev/null
if [ $? -gt 0 ]; then
  echo "Create group [${USER_NAME}] error."
  exit 3
fi
useradd -g ${USER_NAME} -d ${USER_HOME:-/home/${USER_NAME}} -m -s /bin/bash ${USER_NAME} 2>/dev/null
if [ $? -gt 0 ]; then
  echo "Create user [${USER_NAME}] error."
  exit 3
fi
passwd ${USER_NAME} <<EOF >/dev/null 2>&1
${USER_PASS:-GBase123}
${USER_PASS:-GBase123}
EOF
mkdir -p ${USER_HOME}/users 2>/dev/null
chmod 755 ${USER_HOME} 2>/dev/null
chown ${USER_NAME}:${USER_NAME} ${USER_HOME} 2>/dev/null
chmod 777 ${USER_HOME}/users 2>/dev/null
chown ${USER_NAME}:${USER_NAME} ${USER_HOME}/users 2>/dev/null

##### Unzip software and install
loginfo "Unziping [${SOFTPACKNAME}]."
mkdir -p ${WORKDIR}/install 2>/dev/null
cd ${WORKDIR}/install
tar -xf ${WORKDIR}/${SOFTPACKNAME} 2>/dev/null
if [ ! -x "ids_install" ]; then
  echo "ids_install not exists."
fi

mkdir -p $INSTALL_DIR 2>/dev/null
chown ${USER_NAME}:${USER_NAME} $INSTALL_DIR 2>/dev/null
chmod 755 $INSTALL_DIR 2>/dev/null

# ids_install
loginfo "Execute software install, this will take a moment."
timeout 600 ${WORKDIR}/install/ids_install -i silent -DLICENSE_ACCEPTED=TRUE -DUSER_INSTALL_DIR=${INSTALL_DIR:-/opt/${USER_NAME}}

###### Init database
[ ! -d /etc/${USER_NAME} ] && mkdir -p /etc/${USER_NAME} 2>/dev/null
echo "USERS:daemon" > /etc/${USER_NAME}/allowed.surrogates

# profile
loginfo "Building ~${USER_NAME}/.bash_profile ."
cat >> $USER_HOME/.bash_profile <<EOF 2>/dev/null
export GBASEDBTDIR=${INSTALL_DIR}
export GBASEDBTSERVER=${GBASESERVER}
export ONCONFIG=onconfig.\${GBASEDBTSERVER}
export PATH=\${GBASEDBTDIR}/bin:\${PATH}

export DB_LOCALE=${GBASELOCALE:-zh_CN.utf8}
export CLIENT_LOCALE=${GBASELOCALE:-zh_CN.utf8}
export GL_USEGLU=1
EOF

# sqlhosts
loginfo "Building ${INSTALL_DIR}/etc/sqlhosts ."
echo "$GBASESERVER onsoctcp $IPADDR $PORTNO" > $INSTALL_DIR/etc/sqlhosts
chown ${USER_NAME}:${USER_NAME} $INSTALL_DIR/etc/sqlhosts

# onconfig
CFGFILE=$INSTALL_DIR/etc/onconfig.$GBASESERVER
cp $INSTALL_DIR/etc/onconfig.std $CFGFILE
loginfo "Building $CFGFILE ."

sed -i "s#^ROOTPATH.*#ROOTPATH $DATADIR/rootdbs#g" $CFGFILE
sed -i "s#^ROOTSIZE.*#ROOTSIZE $ROOTSIZE#g" $CFGFILE
sed -i "s#^DBSERVERNAME.*#DBSERVERNAME $GBASESERVER#g" $CFGFILE
sed -i "s#^LTAPEDEV.*#LTAPEDEV /dev/null#g" $CFGFILE
sed -i "s#^USERMAPPING.*#USERMAPPING ADMIN#g" $CFGFILE
sed -i "s#^DEF_TABLE_LOCKMODE.*#DEF_TABLE_LOCKMODE row#g" $CFGFILE

chown ${USER_NAME}:${USER_NAME} $CFGFILE

# datadir
loginfo "Creating DATADIR: ${DATADIR} ."
mkdir -p $DATADIR
chown ${USER_NAME}:${USER_NAME} $DATADIR
TMPDIR=$(pwd)
cd $DATADIR
> rootdbs
touch plogdbs llogdbs sbspace1 tempdbs1 datadbs1
chown ${USER_NAME}:${USER_NAME} rootdbs plogdbs llogdbs sbspace1 tempdbs1 datadbs1
chmod 660 rootdbs plogdbs llogdbs sbspace1 tempdbs1 datadbs1
cd $TMPDIR

# oninit
loginfo "Start run database init: oninit -ivy"
su - ${USER_NAME} -c "timeout 600 oninit -ivy"

echo -e "OK"
loginfo "Creating system database.\c"
for w in {1..5}
do
  sleep 3
  echo -e ".\c"
done

while :
do
  sleep 3
  echo -e ".\c"
  NUMDB=$(su - ${USER_NAME} -c 'echo "select count(*) numdb from sysdatabases;" | dbaccess sysmaster - 2>/dev/null')
  NUMDB=$(echo $NUMDB | awk '{printf("%d\n",$2)}')
  if [ ${NUMDB} -gt 3 ]; then
    break
  else
    sleep 3
    echo -e ".\c"
  fi
done

## create dbspace.
echo -e ""
loginfo "Creating dbspace plogdbs."
su - ${USER_NAME} -c "onspaces -c -d plogdbs -p $DATADIR/plogdbs -o 0 -s $PLOGSIZE >/dev/null 2>&1"

loginfo "Creating dbspace llogdbs."
su - ${USER_NAME} -c "onspaces -c -d llogdbs -p $DATADIR/llogdbs -o 0 -s $LLOGSIZE >/dev/null 2>&1"

loginfo "Creating dbspace tempdbs1"
su - ${USER_NAME} -c "onspaces -c -d tempdbs1 -p $DATADIR/tempdbs1 -t -o 0 -s $TEMPSIZE $PAGESIZE >/dev/null 2>&1"

loginfo "Creating smart blob space sbspace1"
su - ${USER_NAME} -c "onspaces -c -S sbspace1 -p $DATADIR/sbspace1 -o 0 -s $SBSPACESIZE >/dev/null 2>&1"

loginfo "Creating dbspace datadbs1"
su - ${USER_NAME} -c "onspaces -c -d datadbs1 -p $DATADIR/datadbs1 -o 0 -s $DATASIZE $PAGESIZE >/dev/null 2>&1"

## change chunk extend able on
loginfo "Changing auto extend able on for chunk datadbs1"
ADMIN_SQLFILE=${INSTALL_DIR}/temp/admin_sqlfile.sql
mkdir -p ${INSTALL_DIR}/temp
cat << ! > $ADMIN_SQLFILE 2>&1
EXECUTE FUNCTION task ("modify chunk extendable on", 6);
!
if [ -s $ADMIN_SQLFILE ]; then
  chown ${USER_NAME}:${USER_NAME} ${INSTALL_DIR}/temp
  chown ${USER_NAME}:${USER_NAME} $ADMIN_SQLFILE
  su - ${USER_NAME} -c "dbaccess sysadmin $ADMIN_SQLFILE >/dev/null 2>&1"
fi

## create mapping default user
loginfo "Creating default user for mapping user"
ADMIN_SQLFILE=${INSTALL_DIR}/temp/mapping_sqlfile.sql
mkdir -p ${INSTALL_DIR}/temp
cat << ! > $ADMIN_SQLFILE 2>&1
CREATE DEFAULT USER WITH PROPERTIES USER daemon HOME "${USER_HOME}/users";
!
if [ -s $ADMIN_SQLFILE ]; then
  chown ${USER_NAME}:${USER_NAME} ${INSTALL_DIR}/temp
  chown ${USER_NAME}:${USER_NAME} $ADMIN_SQLFILE
  su - ${USER_NAME} -c "dbaccess sysuser $ADMIN_SQLFILE >/dev/null 2>&1"
fi

## physical log & logical log
loginfo "Moving physical log to plogdbs."
PLOGFILE=$(echo $PLOGSIZE | awk '{printf("%d\n",substr($1,1,1) * 10 ^ (length($1) - 1))}')
su - ${USER_NAME} -c "onparams -p -d plogdbs -s $PLOGFILE -y >/dev/null 2>&1"

loginfo "Adding 10 logical log file in llogdbs."
LLOGFILE=$(echo $LLOGSIZE | awk '{printf("%d\n",substr($1,1,1) * 10 ^ (length($1) - 1))}')
NEWFILE=$(expr $LLOGFILE / 10)
for w in {1..10}
do
  su - ${USER_NAME} -c "onparams -a -d llogdbs -s $NEWFILE >/dev/null 2>&1"
done

loginfo "Moving CURRENT logical log to new logical file."
while :
do
  CURRLOG=$(su - ${USER_NAME} -c "onmode -l; onmode -c; onstat -l" | awk '/U---C-L/{print $2}')
  if [ $CURRLOG -gt 6 ]; then
    break
  else
    sleep 1
  fi
done

loginfo "Droping logical log file which in rootdbs."
for e in {1..6}
do
  su - ${USER_NAME} -c "onparams -d -l $e -y >/dev/null 2>&1"
done

###### change config
loginfo "Creating file \$INSTALL_DIR/etc/sysadmin/stop ."
if [ ! -f $INSTALL_DIR/etc/sysadmin/stop ]; then
  touch $INSTALL_DIR/etc/sysadmin/stop
  chown ${USER_NAME}:${USER_NAME} $INSTALL_DIR/etc/sysadmin/stop
  chmod 644 $INSTALL_DIR/etc/sysadmin/stop
fi

## cfg with static value
loginfo "Optimizing database config."
sed -i "s#^PHYSBUFF.*#PHYSBUFF 1024#g" $CFGFILE
sed -i "s#^LOGBUFF.*#LOGBUFF 1024#g" $CFGFILE
sed -i "s#^DBSPACETEMP.*#DBSPACETEMP tempdbs1#g" $CFGFILE
sed -i "s#^SBSPACENAME.*#SBSPACENAME sbspace1#g" $CFGFILE
sed -i "s#^SYSSBSPACENAME.*#SYSSBSPACENAME sbspace1#g" $CFGFILE
sed -i "s#^NUMFDSERVERS.*#NUMFDSERVERS 32#g" $CFGFILE
sed -i "s#^MULTIPROCESSOR.*#MULTIPROCESSOR 1#g" $CFGFILE
sed -i "s#^AUTO_TUNE.*#AUTO_TUNE 0#g" $CFGFILE
sed -i "s#^CLEANERS.*#CLEANERS 32#g" $CFGFILE
sed -i "s#^STACKSIZE.*#STACKSIZE 512#g" $CFGFILE
sed -i "s#^ALLOW_NEWLINE.*#ALLOW_NEWLINE 1#g" $CFGFILE
sed -i 's#^USELASTCOMMITTED.*#USELASTCOMMITTED "COMMITTED READ"#g' $CFGFILE
sed -i "s#^DS_MAX_QUERIES.*#DS_MAX_QUERIES 5#g" $CFGFILE
sed -i "s#^DS_TOTAL_MEMORY.*#DS_TOTAL_MEMORY 1024000#g" $CFGFILE
sed -i "s#^DS_NONPDQ_QUERY_MEM.*#DS_NONPDQ_QUERY_MEM 256000#g" $CFGFILE
sed -i "s#^TEMPTAB_NOLOG.*#TEMPTAB_NOLOG 1#g" $CFGFILE
sed -i "s#^DUMPSHMEM.*#DUMPSHMEM 0#g" $CFGFILE
# dynamic value
sed -i "s#^NETTYPE.*#NETTYPE soctcp,${CFG_NETPOOL},200,CPU#g" $CFGFILE
sed -i "s#^VPCLASS.*cpu.*#VPCLASS cpu,num=${CPUVP},noage#g" $CFGFILE
sed -i "s#^DIRECT_IO.*#DIRECT_IO ${CFG_DIRECT_IO}#g" $CFGFILE
sed -i "s#^LOCKS.*#LOCKS ${CFG_LOCKS}#g" $CFGFILE
sed -i "s#^SHMVIRTSIZE.*#SHMVIRTSIZE ${CFG_SHMVIRTSIZE}#g" $CFGFILE
sed -i "s#^SHMADD.*#SHMADD ${CFG_SHMADD}#g" $CFGFILE
sed -i "s#^SHMTOTAL.*#SHMTOTAL ${CFG_SHMTOTAL}#g" $CFGFILE

sed -i "s#^BUFFERPOOL.*size=2.*#BUFFERPOOL size=2K,buffers=${CFG_2KPOOL},lrus=8,lru_min_dirty=50,lru_max_dirty=60#g" $CFGFILE
if [ $NUMMEM -gt 8192 ]; then
  sed -i "s#^BUFFERPOOL.*size=16.*#BUFFERPOOL size=16K,buffers=${CFG_16KPOOL},lrus=8,lru_min_dirty=50,lru_max_dirty=60#g" $CFGFILE
fi

####### restart database
loginfo "Restart GBase 8s Database Server."
su - ${USER_NAME} -c "timeout 300 onmode -ky"
sleep 5
su - ${USER_NAME} -c "timeout 300 oninit -vy"
loginfo "Finish."

exit 0
