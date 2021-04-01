#!/bin/bash
##################################################################
# Filename: CleanAll.sh
# Function: Clean GBase 8s Auto Install.
# Write by: liaojinqing@gbase.cn
# Version : 1.3.11   update date: 2021-03-18
##################################################################
##### Define Parameter
##### Get Parameter
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -u)
        USER_NAME="$2";   shift 2
        ;;
    *)
        cat <<!
Usage:
    CleanAll.sh [-u user]

        -u user    The user name for SYSDBA, gbasedbt/informix, default is gbasedbt

!
        exit 1
        ;;
  esac
done

USER_NAME=${USER_NAME:-gbasedbt}
INSTALL_DIR=/opt/gbase
WORKDIR=$(pwd)

#### do clean
su - ${USER_NAME} -c "onmode -ky"
su - ${USER_NAME} -c "onclean -ky"
ps -ef | awk '/oninit/ && $3==1{print "kill -9 "$2}' | sh
userdel -rf ${USER_NAME} 2>/dev/null
groupdel ${USER_NAME} 2>/dev/null

if [ -d $INSTALL_DIR -a ! x$INSTALL_DIR = x/ ]; then
  read -p "Drop directory [$INSTALL_DIR]? [Y/N] " ISDROP 
  if [ x"${ISDROP}" = x"Y" -o x"${ISDROP}" = x"y" ];then 
    rm -rf ${INSTALL_DIR} 2>/dev/null
  else
    echo "Directory [$INSTALL_DIR] not clean."
  fi
fi

if [ -d ${WORKDIR}/install ]; then
  rm -rf ${WORKDIR}/install 2>/dev/null
fi

exit 0
