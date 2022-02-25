#!/bin/bash

memory=$(free -m | awk '/^Mem/ {print $2","$3","$4","$5","$6","$7}')
swap=$(free -m | awk '/^Swap/ {print $2","$3","$4}')
path=$(du -sh /home/alvin/ | awk '{print $2","$1}')
echo "$memory,$swap,$path" >> /home/alvin/Sistem_Operasi/inites/log/"metrics_$(date +"%Y%m%d%I%M%S").log"
