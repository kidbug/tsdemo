#!/bin/bash

TRUE=1
FLAG="cpu"
SEC=30

USAGE="Usage:  $0 [ -f cpu | io | mem | cs | tcp | ps ] [ -s sleep-seconds ]"
while getopts "h?f:s:" opt; do
    case "$opt" in
    f)  FLAG=$OPTARG
        ;;
    s)  SEC=$OPTARG
        ;;
    h|\?)
        echo $USAGE
        exit 0
        ;;
    *)
        echo $USAGE
        exit 1
        ;;
    esac
done


while [ TRUE ]
do
    case "$FLAG" in
        "cpu")
            # average usage across all CPUs
            # column titles: %user %nice %system %iowait %steal %idle
            sar  1 1 | awk  '$1="" ; $2 ="" ; END{print}' | sed '1,$s/  //'
            ;;
        "io")
            # disk i/o transfer rates
            # column titles: tps rtps wtps bread/s bwrtn/s
            sar -b  1 1 | awk  '$1="" ; END{print}' | sed '1,$s/ //'
            ;;
        "mem")
            # free and used memory
            # column titles: kbmemfree kbmemused %memused kbbuffers kbcached kbcommit %commit kbactive kbinact kbdirty
            sar -r  1 1 | awk  '$1="" ; END{print}' | sed '1,$s/ //'
            ;;
        "cs")
            # processes created and context switches per second
            # column titles: proc/s cswch/s
            sar -w  1 1 | awk  '$1="" ; END{print}' | sed '1,$s/ //'
            ;;
        "tcp")
            # tcpv4 network traffic
            # colunm titles: active/s passive/s iseg/s oseg/s
            sar -n TCP  1 1 | awk  '$1="" ; END{print}' | sed '1,$s/ //'
            ;;
        "ps")
            # top process
            # colunm titles: pid user pr ni virt res shr s %cpu %mem time+ command
            #top -n 1 | head --lines=8 | awk 'END{print}'|  sed '1,$s/   / /g ; 1,$s/  / /g ; 1,$s/ $//'
            top -n 1 | head --lines=8 | awk 'END{print}'|  sed '1,$s/   / /g ; 1,$s/  / /g ; 1,$s/ $//' | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'
            ;;
        *)
            # error
            echo $USAGE
            exit 1
    esac

    sleep $SEC
done
