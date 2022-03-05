#!/bin/bash

memory=$(free -m | awk '/^Mem/ {print $2","$3","$4","$5","$6","$7}')
swap=$(free -m | awk '/^Swap/ {print $2","$3","$4}')
path=$(du -sh /home/satrio/ | awk '{print $2","$1}')
namafile="metrics_$(date +"%Y%m%d%I%M%S").log"
echo "$memory,$swap,$path" >> /home/satrio/log/$namafile
echo "$memory,$swap,$path" >> /home/satrio/log/temporary.txt 
cd /home/satrio/log/
chown satrio metrics_2*
chmod 400 metrics_2*
rm metrics.log
