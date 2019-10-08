#!/bin/bash
#
# Filename: CleanAll.sh
# Function: Clean GBase 8s Auto Install.
#
##### Define Parameter
USER_NAME=$(awk -F'=' '/^USER_NAME/{print $2}' AutoInit_GBase8s.sh)
USER_HOME=$(awk -F'=' '/^USER_HOME/{print $2}' AutoInit_GBase8s.sh)
INSTALL_DIR=$(awk -F'=' '/^INSTALL_DIR/{print $2}' AutoInit_GBase8s.sh)
WORKDIR=$(pwd)

#### do clean
su - ${USER_NAME} -c "onmode -ky"
su - ${USER_NAME} -c "onclean -ky"
ps -ef | awk '/oninit/ && $3==1{print "kill -9 "$2}' | sh
userdel -rf ${USER_NAME} 2>/dev/null
groupdel ${USER_NAME} 2>/dev/null
rm -rf ${INSTALL_DIR} 2>/dev/null
rm -rf ${WORKDIR}/install 2>/dev/null
