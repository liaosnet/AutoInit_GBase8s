#!/bin/bash
#
# Filename: CleanAll.sh
# Function: Clean GBase 8s Auto Install.
#
##### Define Parameter
USER_NAME=$(awk -F'=' '/^USER_NAME/{print $2}' AutoInit_GBase8s.sh)
USER_HOME=$(awk -F'=' '/^USER_HOME/{print $2}' AutoInit_GBase8s.sh)
#INSTALL_DIR=$(awk -F'=' '/^INSTALL_DIR/{print $2}' AutoInit_GBase8s.sh)
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
