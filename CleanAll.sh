#!/bin/sh
#
# Filename: CleanAll.sh
# Function: Clean GBase 8s Auto Install.
#
##### Define Parameter
USER_NAME=gbasedbt
USER_HOME=/home/gbase
INSTALL_DIR=/opt/gbase
WORKDIR=$(pwd)

#### do clean
su - ${USER_NAME} -c "onmode -ky"
su - ${USER_NAME} -c "onclean -ky"
ps -ef | awk '/oninit/ && $3==1{print "kill -9 "$2}' | sh
userdel -rf ${USER_NAME} 2>/dev/null
groupdel ${USER_NAME} 2>/dev/null
rm -rf ${INSTALL_DIR} 2>/dev/null
rm -rf ${WORKDIR}/install 2>/dev/null
