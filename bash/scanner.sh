#!/bin/bash
echo Enumerator

HOSTS=$(nmap -sP -T5 -n -oG - "$1" | grep 'Status: Up' | awk '{print $2}' 2>&1)
for i in $HOSTS;
	do
        echo "$i"
	curl -m0.5 -I "$i";
done
