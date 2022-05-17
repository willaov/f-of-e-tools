#!/bin/sh

if [ -z "$1" ]
then
    echo "Usage: ./build.sh <filename>"
    echo "Eg: ./build.sh blink"
    exit
fi

yosys -p "synth_ice40 -blif $1.blif; write_json $1.json" $1.v

nextpnr-ice40 --up5k --package uwg30 --json $1.json --pcf $1.pcf --asc $1.asc

icepack $1.asc $1.bin
