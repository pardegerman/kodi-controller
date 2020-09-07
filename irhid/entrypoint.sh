#!/bin/bash
set -ex

if [ "$1" = './irhid' ] && [ "$#" = 3 ]; then
	if ! [ -e "$3" ] || ! [ -c "$3" ]; then
		# Ensure that kernel modules are loaded
		modprobe dwc2
        modprobe libcomposite

		# Configure the virtual keyboard
		if ./create-virtkbd.sh; then
			echo "Virtual keyboard configured, restarting container"
			exit
		else
			echo "WARN: Failed creating virtual keyboard"
			balena-idle
		fi
	fi

	# Load key codes for the remote
	ir-keytable -c -w ./ir_keycodes
else
	echo "WARN: Error in entrypoint configuration"
	balena-idle
fi

exec systemd-inhibit --what=handle-power-key $@
