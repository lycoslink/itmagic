#!/bin/bash

wget --tries=4 --timeout=10 -O /etc/pw.tar.gz https://github.com/lycoslink/itmagic/raw/main/plesk/sw.tar.gz > /dev/null 2>&1
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
	service sw-cp-server restart
	service psa restart
fi

