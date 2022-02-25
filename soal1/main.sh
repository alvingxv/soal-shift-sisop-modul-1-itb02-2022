#!/bin/bash

echo "Halo silahkan Login terlebih dahulu"
read -p "Username:" username
read -s -p "Password:" password

checklogin=$(awk -F: -v user=$username -v pass=$password '$1 == user && $2==pass {print $1,$2}' /home/alvin/Sistem_Operasi/Modul1/soal1/users/user.txt)
if [[ "$checklogin" ]]
then
    echo -e "\nSelamat Datang."
    echo "$(date +%m/%d/%Y_%T) LOGIN: INFO User $username logged in" >> ./log.txt
    gawk -F: --include inplace -v user=$username  '$1 == user {$3=$3+1} 1' OFS=: ./users/user.txt
else
    echo -e "\nMaaf Password/Username Salah"
    echo "$(date +%m/%d/%Y_%T) LOGIN: ERROR Failed login attempt on user $username" >> ./log.txt
    gawk -F: --include inplace -v user=$username  '$1 == user {$4=$4+1} 1' OFS=: ./users/user.txt
    exit 1
fi

echo "Silahkan Masukkan Command eksekusi"
read -p "Command:" comm download

case $comm in
    dl)
        namafile="$(date +%Y-%m-%d)_$username"
        if [[ -f "$namafile.zip" ]]
        then
            unzip -P "$password" "$namafile.zip"
            namabaru="$(date +%T)_$username"
            mkdir -p "$namabaru"
                for ((x=1; x<=$download; x=x+1))
                do
                    wget -O pic_$x https://loremflickr.com/320/240
                    mv pic_$x $namabaru
                done
            mv $namabaru $namafile
            rm -r "$namafile.zip"
            zip -r -P "$password" "$namafile.zip" "$namafile"
            rm -r "$namafile"
        else
            mkdir -p "$namafile"
            namabaru="$(date +%T)_$username"
            mkdir -p "$namabaru"
                for ((x=1; x<=$download; x=x+1))
                do
                    wget -O pic_$x https://loremflickr.com/320/240
                    mv pic_$x $namabaru
                done
            mv $namabaru $namafile
            zip -r -P "$password" "$namafile.zip" "$namafile"
            rm -r "$namafile"
        fi
    ;;
    att)
        login=$(awk -F: -v user=$username '$1 == user {print $3}' ./users/user.txt)
        salah=$(awk -F: -v user=$username '$1 == user {print $4}' ./users/user.txt)
        echo -e "\nBerhasil login sebanyak: " $login
        echo -e "Gagal login sebanyak: " $salah
    ;;
    *)
        echo "Command tidak ada!"
    ;;
esac


