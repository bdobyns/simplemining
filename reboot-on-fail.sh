#!/bin/bash
cd ~  
TOOMANY=10 
MINHASHRATE=20
HOWMANY_FILE=~/badhashes  
CURRENT_HASHRATE=`curl -s localhost:4444 2>/dev/null | jq .Session.Performance_Summary | cut -f 1 -d .`
HOWMANY=`cat $HOWMANY_FILE`  

if [ -z $CURRENT_HASHRATE ] ; then
    # starting up
    echo 0 > $HOWMANY_FILE
elif [ $CURRENT_HASHRATE -le $MINHASHRATE ] ; then
    if [ ! -e $HOWMANY_FILE ] ; then
        echo 1 > $HOWMANY_FILE   
    else
        if [ $HOWMANY -ge $TOOMANY ] ; then
     	    rm $HOWMANY 	
	    echo -n hashRate at or below $MINHASHRATE for $HOWMANY minutes. rebooted on >>${HOWMANY_FILE}.log 	
	    date >>${HOWMANY_FILE}.log         
	    sync; sync; sync; sync
	    sudo reboot     
	else
	    echo $[ $HOWMANY + 1 ] >>$HOWMANY_FILE
	fi   
    fi   
    echo -n hashRate at or below $MINHASHRATE for $( cat $HOWMANY_FILE ) minutes. >>${HOWMANY_FILE}.log   
    date >>${HOWMANY_FILE}.log 
else     
    if [ -z $HOWMANY ] || [ $HOWMANY -ne 0 ] ; then
        echo -n hashRate back to $CURRENT_HASHRATE after $( cat $HOWMANY_FILE ) minutes. >>${HOWMANY_FILE}.log         
	date >>${HOWMANY_FILE}.log     
    fi     
    echo 0 > $HOWMANY_FILE 
fi
sync ; sync ; sync
