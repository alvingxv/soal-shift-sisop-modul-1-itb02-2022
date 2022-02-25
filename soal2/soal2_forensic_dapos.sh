#!/bin/bash

#2b
awk -F: '$3==$3{++jumlah} {tot[$3]++;} END {for (i in tot)count++; printf "Rata-rata serangan adalah sebanyak %d requests per jam\n", jumlah/count'} log_website_daffainfo.log >> ratarata.txt
#2c
awk -F: '{print $1}' log_website_daffainfo.log | sort -n | uniq -c | sort -rn | head -n 1 | awk '{print "IP yang paling banyak mengakses server adalah: " $2 " sebanyak " $1 " requests"}' >> result.txt
#2d
awk -F: '{if ($9 ~ /curl/) jumlah++} END {printf "Ada %d requests yang menggunakan curl sebagai user-agent\n", jumlah'} log_website_daffainfo.log >> result.txt
#2e
awk -F: '{if ($2 ~ "22/Jan/2022" && $3 ~ /02/) print $1 " jam 2 pagi"'} log_website_daffainfo.log >> result.txt

