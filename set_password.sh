#!/bin/bash
if [ -e /root/.symcon ]; then
	echo "Enter new IPSymcon remote concole password:"
	read -s PASS
	B64=$(echo -n "$PASS" |base64)
	#delete alt entry, if any
	sed -i -e '/Password=/d' /root/.symcon
	#set new entry
	sed -i -e "$ a Password=${B64}" /root/.symcon
	echo "finished, Please restart to activate!"
else
	echo "/root/.symcon missed"
	echo "please set license first via remote console connecting to port 3777"
	echo "this will create /root/.symcon"
fi
