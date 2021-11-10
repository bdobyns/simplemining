#!/bin/bash
cd ~  
TOOMANY=10 
MINHASHRATE=20
HOWMANY_FILE=~/badhashes  
CURRENT_HASHRATE=`curl -s localhost:4444 2>/dev/null | jq .Session.Performance_Summary | cut -f 1 -d .`
HOWMANY=`cat $HOWMANY_FILE`  

logmsg() {
     echo -n $* >>${HOWMANY_FILE}.log
     date >>${HOWMANY_FILE}.log
     
     echo -n $* >>/var/tmp/consoleSys.log
     date >>/var/tmp/consoleSys.log
}

if [ -z $CURRENT_HASHRATE ] ; then
    # starting up
    echo 0 > $HOWMANY_FILE
elif [ $CURRENT_HASHRATE -le $MINHASHRATE ] ; then
    if [ ! -e $HOWMANY_FILE ] ; then
        echo 1 > $HOWMANY_FILE   
    else
        if [ ! -z $HOWMANY ] && [ $HOWMANY -ge $TOOMANY ] ; then
     	    rm $HOWMANY 	
	    logmsg hashRate at or below $MINHASHRATE for $HOWMANY minutes. rebooted on 
	    sync; sync; sync; sync
	    sudo reboot     
	else
	    echo $[ $HOWMANY + 1 ] >>$HOWMANY_FILE
	fi   
    fi   
    logmsg hashRate at or below $MINHASHRATE for $( cat $HOWMANY_FILE ) minutes. 
else     
    if [ -z $HOWMANY ] ; then 
        logmsg hashRate back to $CURRENT_HASHRATE after unknown time. 
    elif [ $HOWMANY -ne 0 ] ; then
        logmsg hashRate back to $CURRENT_HASHRATE after $( cat $HOWMANY_FILE ) minutes. 
    fi     
    echo 0 > $HOWMANY_FILE 
fi
sync ; sync ; sync
