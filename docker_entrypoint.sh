#!/bin/bash

# ---------------
# Start IP-Symcon
# ---------------

# Versteckte Files (dot-files) bearbeiten (cp,mv,rm)
shopt -s dotglob

PARAM="$@"

#test if configuration in /root exits.
#if not -> copy template files
if [ -e /root/.profile ]; then
    echo "/root files exists"
else
    echo "/root files not exists "
    echo "Copy template files "
    cp -R /root.org/* /root
fi

if [ ! -e /root/.symcon ]; then
	echo "/root/.symcon missed"
	echo "please set license first via remote console connecting to port 3777"
	echo "this will create /root/.symcon"
	echo "then use set_password.sh to set the remo´te access password"
fi

if [ -z "$PARAM" ]; then
	echo "Start IP-Symcon"
	/usr/bin/symcon
else
	exec $PARAM
fi
