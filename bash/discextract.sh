#!/usr/bin/env nix-shell
#! nix-shell -p jq aria2 -i bash

if [[ "$1" == "" ]]
then
    echo Usage: $0 package.zip
    exit 1
fi

PZ=$(realpath $1)

mkdir discextract
cd discextract
7z x $PZ
find -name messages.csv -exec grep -R http {} \; | sed  's/http/\nhttp/g' | sed 's/,/\n,/g' | grep http | sort | uniq > urls
aria2c -c -j16 -x16 -i urls