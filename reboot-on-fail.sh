#!/bin/bash
cd ~  
TOOMANY=10 # it takes a few minutes to get everything stable after a reboot.
MINHASHRATE=26 # at least one GPU running, even if not LHR mode
HOWMANY_FILE=~/badhashes  

logmsg() {
     NOW=$( date '+%Y-%m-%d %H:%M:%S' )
     echo $NOW $* " ">>${HOWMANY_FILE}.log
     echo $NOW $* " ">>/var/tmp/consoleSys.log
}

if [ ! -e /var/tmp/rigStarted.run ] ; then
    # the rig is not running properly.  
    # don't reboot and get into a loop
    rm $HOWMANY_FILE
    exit
fi

# lolminer only for .Session.Performance_Summary
# CURRENT_HASHRATE=`curl -s localhost:4444 2>/dev/null | jq .Session.Performance_Summary | cut -f 1 -d .`
CURRENT_HASH_SEC=`/root/utils/stats_rig.sh | jq -r .hash | cut -f 1 -d . `
if [ -z $CURRENT_HASH_SEC ] ; then
    # starting up, or not running
    logmsg 'hashRate is null (can not find miner?)'
    CURRENT_HASHRATE=0
else
    # stats_rig.sh reports Hash/s not MH/s
    CURRENT_HASHRATE=$[ $CURRENT_HASH_SEC / 1000 / 1000 ]
fi

HOWMANY=`cat $HOWMANY_FILE`  
if [ -z $HOWMANY ] ; then
    # likely right after a reboot, there's no record
    HOWMANY=0
fi
HOWMANY=$[ $HOWMANY + 1 ]

if [ $CURRENT_HASHRATE -le $MINHASHRATE ] ; then
    if [ ! -e $HOWMANY_FILE ] ; then
        echo $HOWMANY > $HOWMANY_FILE   
    else
        if [ ! -z $HOWMANY ] && [ $HOWMANY -ge $TOOMANY ] ; then
	    logmsg hashRate at or below $MINHASHRATE for $HOWMANY minutes. rebooted because we exceeded $TOOMANY minutes.
	    rm $HOWMANY_FILE
	    sync; sync; sync; sync
	    sudo reboot     
	    exit 0
	else
	    echo $HOWMANY >$HOWMANY_FILE
	fi   
    fi   
    logmsg hashRate at or below $MINHASHRATE for $HOWMANY minutes. 
else     
    if [ $HOWMANY -ne 1 ] ; then
        logmsg hashRate back to $CURRENT_HASHRATE after $HOWMANY minutes.
    fi     
    echo 0 > $HOWMANY_FILE 
fi
sync ; sync ; sync
