#!/bin/bash
cd ~  
TOOLONG=7 # it takes a few minutes to get everything stable after a reboot.
MIN_MHS=5 # at least one GPU running, even if not LHR mode
HOWLONG_FILE=~/badhashes  

logmsg() {
     NOW=$( date '+%Y-%m-%d %H:%M:%S' )
     echo $NOW $* " ">>${HOWLONG_FILE}.log
     echo $NOW $* " ">>/var/tmp/consoleSys.log
}

if [ ! -e /var/tmp/rigStarted.run ] ; then
    # the rig is not running properly.  
    # don't reboot and get into a loop
    rm $HOWLONG_FILE
    exit
fi

# lolminer only for .Session.Performance_Summary
# CURRENT_MHS=`curl -s localhost:4444 2>/dev/null | jq .Session.Performance_Summary | cut -f 1 -d .`
CURRENT_HASH_SEC=`/root/utils/stats_rig.sh | jq -r .hash | cut -f 1 -d . `
if [ -z $CURRENT_HASH_SEC ] ; then
    # starting up, or not running
    logmsg 'hashRate is null (can not find miner?)'
    CURRENT_MHS=0
else
    # stats_rig.sh reports Hash/s not MH/s
    CURRENT_MHS=$[ $CURRENT_HASH_SEC / 1000 / 1000 ]
fi

HOWLONG=`cat $HOWLONG_FILE`  
if [ -z $HOWLONG ] ; then
    # likely right after a reboot, there's no record
    HOWLONG=0
fi
HOWLONG=$[ $HOWLONG + 1 ]

if [ $CURRENT_MHS -le $MIN_MHS ] ; then
    if [ ! -e $HOWLONG_FILE ] ; then
        echo $HOWLONG > $HOWLONG_FILE   
    else
        if [ ! -z $HOWLONG ] && [ $HOWLONG -ge $TOOLONG ] ; then
	    logmsg hashRate $CURRENT_MHS below $MIN_MHS for $HOWLONG minutes. rebooted because we exceeded $TOOLONG minutes.
	    rm $HOWLONG_FILE
	    sync; sync; sync; sync
	    sudo reboot     
	    exit 0
	else
	    echo $HOWLONG >$HOWLONG_FILE
	fi   
    fi   
    logmsg hashRate $CURRENT_MHS below $MIN_MHS for $HOWLONG minutes. 
else     
    if [ $HOWLONG -ne 1 ] ; then
        logmsg hashRate back to $CURRENT_MHS after $HOWLONG minutes.
    fi     
    echo 0 > $HOWLONG_FILE 
fi
sync ; sync ; sync
