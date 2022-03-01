#!/bin/bash

echo "Halo silahkan Register terlebih dahulu"
read -p "Username:" username
read -s -p "Password:" password
char=$(echo -n "$password" | wc -c)
unameexists=$(awk -F: -v user=$username '$1 == user {print $1}' ./users/user.txt)

if [[ "$unameexists" ]]
then
    echo -e "\nUser exists."
    echo "$(date +%m/%d/%Y_%T) REGISTER: ERROR User already exists" >> ./log.txt
    exit 1
elif [[ "$password" =~ [^0-9A-Za-z]+ ]]
then
    echo -e "\nPassword harus Alfabet dan Angka."
    exit 1
elif [[ $char -lt 8 ]]
then
    echo -e "\nPassword harus minimal 8 huruf."
    exit 1
elif ! [[ "$password" =~ [[:upper:]] ]] && [[ "$password" =~ [[:lower:]] ]]
then
    echo -e "\nPassword minimal 1 huruf besar dan 1 huruf kecil"
    exit 1
elif [[ $username == $password ]]
then
    echo -e "\nUsername dan Password tidak boleh sama."
    exit 1
else
    echo "Anda telah terdaftar sebagai User"
fi

echo $username:$password:"0":"0" >> ./users/user.txt
echo "$(date +%m/%d/%Y_%T) REGISTER: INFO User $username registered successfully" >> ./log.txt

