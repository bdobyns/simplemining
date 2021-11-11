#!/bin/bash
cd ~  
TOOMANY=10 # it takes a few minutes to get everything stable after a reboot.
MINHASHRATE=26 # at least one GPU running, even if not LHR mode
HOWMANY_FILE=~/badhashes  
CURRENT_HASHRATE=`curl -s localhost:4444 2>/dev/null | jq .Session.Performance_Summary | cut -f 1 -d .`
HOWMANY=`cat $HOWMANY_FILE`  

logmsg() {
     NOW=$( date '+%Y-%m-%d %H:%M:%S' )
     echo $NOW $* " ">>${HOWMANY_FILE}.log
     echo $NOW $* " ">>/var/tmp/consoleSys.log
}

if [ -z $CURRENT_HASHRATE ] ; then
    # starting up, or not running
    logmsg hashRate is null 
    CURRENT_HASHRATE=0
fi

if [ -z $HOWMANY ] ; then
    # right after a reboot, there's no record
    HOWMANY=0
fi
HOWMANY=$[ $HOWMANY + 1 ]

if [ $CURRENT_HASHRATE -le $MINHASHRATE ] ; then
    if [ ! -e $HOWMANY_FILE ] ; then
        echo $HOWMANY > $HOWMANY_FILE   
    else
        if [ ! -z $HOWMANY ] && [ $HOWMANY -ge $TOOMANY ] ; then
     	    rm $HOWMANY
	    logmsg hashRate at or below $MINHASHRATE for $HOWMANY minutes. rebooted because we exceeded $TOOMANY.
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
