#!/bin/sh
set -euo pipefail
trap pwd ERR

cd build

make shift_leds
sudo picotool load -f shift_leds.uf2
sudo picotool reboot
