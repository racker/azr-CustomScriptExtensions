#!/bin/bash
##################################################################################
# Name: installtanium.sh
# Description: Custom Script Extension used to install appropriate package of tanium client
# Authors: Cameron Collins
# Copyright: Rackspace, Inc. 2018.
##################################################################################

########################### GLOBAL VARIABLES #####################################

SERVERNAME=`hostname`
LOGFILE=/root/.rackspace/taniuminstall.log               ## Not In Use
ROOTURL="https://containerd.blob.core.windows.net/tanium/"

## Oracle Linux
TANIUMOEL6=TaniumClient-6.0.314.1579_1.oel6.x86_64.rpm  ## Not Implemented
TANIUMOEL7=TaniumClient-6.0.314.1579_1.oel7.x86_64.rpm  ## Not Implemented

## RHEL/CENT
TANIUMRHEL5=TaniumClient-6.0.314.1579_1.rhe5.x86_64.rpm
TANIUMRHEL6=TaniumClient-6.0.314.1579_1.rhe6.x86_64.rpm
TANIUMRHEL7=TaniumClient-6.0.314.1579_1.rhe7.x86_64.rpm

## Suse
TANIUMSLE11=TaniumClient-6.0.314.1579_1.sle11.x86_64.rpm
TANIUMSLE12=TaniumClient-6.0.314.1579_1.sle12.x86_64.rpm

## Debian
TANIUMDEB6=taniumclient_6.0.314.1579-debian6_amd64.deb  ## Not Implemented

## Ubuntu
TANIUMUBU10=taniumclient_6.0.314.1579-ubuntu10_amd64.deb
TANIUMUBU14=taniumclient_6.0.314.1579-ubuntu14_amd64.deb
TANIUMUBU16=taniumclient_6.0.314.1579-ubuntu16_amd64.deb

########################### FUNCTIONS ############################################

##################################################################################
# Determine the osversion so that we can configure things accordingly
# Sets the variable: $OSVER
##################################################################################

function get_osversion()
{
  #if its a distro based on redhat, it should have this file and we can read it to find out the version number.
  if [[ -e /etc/redhat-release ]]; then 
	  OSVER=`cat /etc/redhat-release`
  elif
    [[ -e /etc/SuSE-release ]]; then
      OSVER=`grep -i suse /etc/SuSE-release`
  else #ubuntu/debian.
	  OSVER=`cat /etc/issue`
  fi
}

function install_tanium()
{
  if [[ $OSVER =~ "release 5"  ]]; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMRHEL5 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMRHEL5

      echo "========================================================================================================================"
      echo "Installing $TANIUMRHEL5 on $SERVERNAME"
      echo "========================================================================================================================"
      rpm -ivh /tmp/$TANIUMRHEL5

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      service TaniumClient stop
      service TaniumClient start


 elif [[ $OSVER =~ "release 6"  ]]; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMRHEL6 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMRHEL6

      echo "========================================================================================================================"
      echo "Installing $TANIUMRHEL6 on $SERVERNAME"
      echo "========================================================================================================================"
      rpm -ivh /tmp/$TANIUMRHEL6

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      service TaniumClient stop
      service TaniumClient start

 elif [[ $OSVER =~ "release 7"  ]]; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMRHEL7 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMRHEL7

      echo "========================================================================================================================"
      echo "Installing $TANIUMRHEL7 on $SERVERNAME"
      echo "========================================================================================================================"
      rpm -ivh /tmp/$TANIUMRHEL7

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      systemctl stop taniumclient
      systemctl start taniumclient

 elif [[ $OSVER =~ "Ubuntu 10" ]]; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMUBU10 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMUBU10

      echo "========================================================================================================================"
      echo "Installing $TANIUMUBU10 on $SERVERNAME"
      echo "========================================================================================================================"
      dpkg -i /tmp/$TANIUMUBU10

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      service taniumclient stop
      service taniumclient start

 elif [[ $OSVER =~ "Ubuntu 14" ]]; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMUBU14 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMUBU14

      echo "========================================================================================================================"
      echo "Installing $TANIUMUBU14 on $SERVERNAME"
      echo "========================================================================================================================"
      dpkg -i /tmp/$TANIUMUBU14

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      service taniumclient stop
      service taniumclient start
 
 elif [[ $OSVER =~ "Ubuntu 16" ]]; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMUBU16 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMUBU16

      echo "========================================================================================================================"
      echo "Installing $TANIUMUBU16 on $SERVERNAME"
      echo "========================================================================================================================"
      dpkg -i /tmp/$TANIUMUBU16

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      systemctl stop taniumclient
      systemctl start taniumclient
 
 elif [[ $OSVER =~ "Server 11" ]] ; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMSLE11 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMSLE11

      echo "========================================================================================================================"
      echo "Installing $TANIUMSLE11 on $SERVERNAME"
      echo "========================================================================================================================"
      rpm -ivh /tmp/$TANIUMSLE11

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      service TaniumClient stop
      service TaniumClient start

 elif [[ $OSVER =~ "Server 12" ]] ; then
      echo "========================================================================================================================"
      echo "Downloading $TANIUMSLE12 on $SERVERNAME"
      echo "========================================================================================================================"
      wget -P /tmp/ $ROOTURL$TANIUMSLE12

      echo "========================================================================================================================"
      echo "Installing $TANIUMSLE12 on $SERVERNAME"
      echo "========================================================================================================================"
      rpm -ivh /tmp/$TANIUMSLE12

      echo "========================================================================================================================"
      echo "Stopping and Starting TaniumClient on $SERVERNAME"
      echo "========================================================================================================================"
      service TaniumClient stop
      service TaniumClient start

 else
    echo "!!OS NOT DETECTED!! Couldn't determine appropriate TaniumClient package for installation.  Aborting!"
    exit 1;

  exit 0

  fi
}


function clean_files {
      echo "========================================================================================================================"
      echo "Cleaning TaniumClient Installation Files on $SERVERNAME"
      echo "========================================================================================================================"
      find /tmp/ -maxdepth 1 -iname "taniumclient*" -exec rm {} \;
}

get_osversion
install_tanium

#clean_files  ## Verified working.  Can uncomment it out to remove the installer if desired.

##################################
##################################
#
## Distros Not implemented (yet?)
#
#Amazon Linux  
#service TaniumClient start
#service TaniumClient stop
#
#Debian  
#service taniumclient start
#service taniumclient stop
#
#Oracle Enterprise Linux 
#systemctl start taniumclient
#systemctl stop taniumclient
#
##################################
##################################


## EOF