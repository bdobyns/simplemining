
if [[ -z ${DISPLAY} && $(tty) == /dev/tty1 ]]; then
  while true; do
    stty sane
    stty onlcr
    if [[ -f /var/tmp/minerPause ]]; then
      # fix terminal newline issue
      xstr=`/root/utils/info.sh onlystats`
      xstr+=`echo -e "\n\e[0m\e[1m\e[32mSimpleMining.net\n\e[0m\e[31mRig is paused\e[0m\n\nYou can resume mining in SimpleMining.net dashboard"`
      clear
      echo "${xstr}"
    else
      screen -x miner 1> /dev/null 2> /dev/null || echo -e "\e[0m\e[1m\e[32mwaiting for screen...\e[0m"
    fi
    sleep 1
  done
fi
TZ='America/New_York' ; export TZ 
MINERDIR=$( echo /root/miner/* | head -1 )
PATH=/root/utils:${PATH}:${MINERDIR}; export PATH
WALLETRVN=RULZGGmeARHMpJKJWPbYAu29j6YaP3ushZ
