# simplemining
addons to simplemining.net crypto os

# **reboot-on-fail.sh** is

* used to reboot when the hasrate falls below a threshold value.  
* This can happen if your network conenction drops (wifi) and doesn't recover, or for other indeterminate reasons.  
* The threshold is near the top of the script as a variable.  
* counts how many minutes have elapsed since the hashrate fell too low, and reboots if TOOMANY is exceeded
* uses /root/utils/stats_rig.sh to get the current hashrate which is miner-independent

# **miner.crontab** 

* a crontab file that runs reboot-on-fail.sh every minute
