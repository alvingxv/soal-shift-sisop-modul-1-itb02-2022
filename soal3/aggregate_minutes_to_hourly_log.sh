#!/bin/env bash

cd /home/satrio/log
tmp=tmp_$(date +\%Y\%m\%d\%H\%M\%S).log
cat metrics_2022* > $tmp
namafile=metrics_agg_$(date +\%Y\%m\%d\%H).log
awk -F, '{ 
mem_total += $1;
mem_used += $2; 
mem_free += $3; 
mem_shared += $4;
mem_buff += $5;
mem_available += $6;
swap_total += $7;
swap_used += $8;
swap_free += $9;
path=$10
path_size+=$11
count++ } 
END { 
print "average "mem_total/count","mem_used/count","mem_free/count","mem_shared/count","mem_buff/count","mem_available/count","swap_total/count","swap_used/count","swap_free/count","path","path_size/count"M";
}' $tmp >> $namafile

mem_total_min=$(awk -F, '{print $1}' $tmp | sort -n | head -n 1 | awk '{print $1}') 
mem_total_max=$(awk -F, '{print $1}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
mem_used_min=$(awk -F, '{print $2}' $tmp | sort -n | head -n 1 | awk '{print $1}')
mem_used_max=$(awk -F, '{print $2}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
mem_free_min=$(awk -F, '{print $3}' $tmp | sort -n | head -n 1 | awk '{print $1}')
mem_free_max=$(awk -F, '{print $3}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
mem_shared_min=$(awk -F, '{print $4}' $tmp | sort -n | head -n 1 | awk '{print $1}')
mem_shared_max=$(awk -F, '{print $4}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
mem_buff_min=$(awk -F, '{print $5}' $tmp | sort -n | head -n 1 | awk '{print $1}')
mem_buff_max=$(awk -F, '{print $5}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
mem_available_min=$(awk -F, '{print $6}' $tmp | sort -n | head -n 1 | awk '{print $1}')
mem_available_max=$(awk -F, '{print $6}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
swap_total_min=$(awk -F, '{print $7}' $tmp | sort -n | head -n 1 | awk '{print $1}')
swap_total_max=$(awk -F, '{print $7}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
swap_used_min=$(awk -F, '{print $8}' $tmp | sort -n | head -n 1 | awk '{print $1}')
swap_used_max=$(awk -F, '{print $8}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
swap_free_min=$(awk -F, '{print $9}' $tmp | sort -n | head -n 1 | awk '{print $1}')
swap_free_max=$(awk -F, '{print $9}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
path=$(awk -F, '{print $10}' $tmp | head -n 1 | awk '{print $1}')
path=$(awk -F, '{print $10}' $tmp | head -n 1 | awk '{print $1}')
path_size_min=$(awk -F, '{print $11}' $tmp | sort -n | head -n 1 | awk '{print $1}')
path_size_max=$(awk -F, '{print $11}' $tmp | sort -nr | head -n 1 | awk '{print $1}')

echo "minimum $mem_total_min,$mem_used_min,$mem_free_min,$mem_shared_min,$mem_buff_min,$mem_available_min,$swap_total_min,$swap_used_min,$swap_free_min,$path,$path_size_min" >> $namafile
echo "maximum $mem_total_max,$mem_used_max,$mem_free_max,$mem_shared_max,$mem_buff_max,$mem_available_max,$swap_total_max,$swap_used_max,$swap_free_max,$path,$path_size_max" >> $namafile
chown satrio $namafile
chmod 400 $namafile
rm "$tmp"
