#!/bin/sh
set -euo pipefail
trap pwd ERR

cd build

make "$1"
sudo picotool load -f "$1".uf2
sudo picotool reboot
