# simplemining
addons to simplemining.net crypto os

**reboot-on-fail.sh** is used to reboot when the hasrate falls below a threshold value.  This can happen if your network conenction drops (wifi) and doesn't recover, or for other indeterminate reasons.  The threshold is near the top of the script as a variable.

**miner.crontab** is a crontab file that runs reboot-on-fail.sh every minute
