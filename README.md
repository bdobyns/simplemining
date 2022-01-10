# simplemining
addons to simplemining.net crypto os

# **reboot-on-fail.sh** 

* used to reboot when the hashrate falls below a threshold value.  
* This can happen if your network conenction drops (wifi) and doesn't recover, or for other indeterminate reasons.  
* The threshold is near the top of the script as a variable.  
* counts how many minutes have elapsed since the hashrate fell too low, and reboots if TOOLONG is exceeded
* uses /root/utils/stats_rig.sh to get the current hashrate which is miner-independent
* keeps a logfile in badhashes.log
* misuses the SRR variables you can set in the web console: srrSerial=TOOLONG, srrSlot=MIN_MHS
* or just edit the script to change the default TOOLONG and MIN_MHS near the top

# **miner.crontab** 

* a crontab file that runs reboot-on-fail.sh every minute
* uses logrotate to control the size of the logfile

# It's Free, you know

but if you found it useful you can donate to

ETH: bad000f10e937680538823e8eb3966dfd80ffce8

RVN: RKQDSrf4o6FAh8ba8FvYLmUz82H6fTaVnB