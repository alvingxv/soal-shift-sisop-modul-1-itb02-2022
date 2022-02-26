# soal-shift-sisop-modul-1-itb02-202

## Laporan Pengerjaan Modul 1 Praktikum Sistem Operasi

### Nama Anggota Kelompok

1. Rachmita Annisa Aulia 5027201032
2. Alvian Ghifari 5027201035
3. Satrio Kamil Widhiwoso 5027201051

# Soal 1

Pada suatu hari, Han dan teman-temannya diberikan tugas untuk mencari foto. Namun, karena laptop teman-temannya rusak ternyata tidak bisa dipakai karena rusak, Han dengan senang hati memperbolehkan teman-temannya untuk meminjam laptopnya. Untuk mempermudah pekerjaan mereka, Han membuat sebuah program.

A. Han membuat sistem register pada script register.sh dan setiap user yang berhasil didaftarkan disimpan di dalam file ./users/user.txt. Han juga membuat sistem login yang dibuat di script main.sh

B. Demi menjaga keamanan, input password pada login dan register harus tertutup/hidden dan password yang didaftarkan memiliki kriteria sebagai berikut

* Minimal 8 karakter
* Memiliki minimal 1 huruf kapital dan 1 huruf kecil
* Alphanumeric
* Tidak boleh sama dengan username

C. Setiap percobaan login dan register akan tercatat pada log.txt dengan format : MM/DD/YY hh:mm:ss **MESSAGE**. Message pada log akan berbeda tergantung aksi yang dilakukan user.

* Ketika mencoba register dengan username yang sudah terdaftar, maka message pada log adalah REGISTER: ERROR User already exists
* Ketika percobaan register berhasil, maka message pada log adalah REGISTER: INFO User **USERNAME** registered successfully
* Ketika user mencoba login namun passwordnya salah, maka message pada log adalah LOGIN: ERROR Failed login attempt on user **USERNAME**
* Ketika user berhasil login, maka message pada log adalah LOGIN: INFO User **USERNAME** logged in

D. Setelah login, user dapat mengetikkan 2 command dengan dokumentasi sebagai berikut:
* dl N ( N = Jumlah gambar yang akan didownload)
    
    Untuk mendownload gambar dari https://loremflickr.com/320/240 dengan jumlah sesuai dengan yang diinputkan oleh user. Hasil download akan dimasukkan ke dalam folder dengan format nama **YYYY-MM-DD_USERNAME**. Gambar-gambar yang didownload juga memiliki format nama **PIC_XX**, dengan nomor yang berurutan (contoh : PIC_01, PIC_02, dst. ).  Setelah berhasil didownload semua, folder akan otomatis di zip dengan format nama yang sama dengan folder dan dipassword sesuai dengan password user tersebut. Apabila sudah terdapat file zip dengan nama yang sama, maka file zip yang sudah ada di unzip terlebih dahulu, barulah mulai ditambahkan gambar yang baru, kemudian folder di zip kembali dengan password sesuai dengan user.
* att
    
    Menghitung jumlah percobaan login baik yang berhasil maupun tidak dari user yang sedang login saat ini.

## Penjelasan Code Soal 1
Dalam soal ini kita diminta untuk membuat sebuah sistem untuk Register user dan Login user. Script untuk register akan dinamakan **register.sh** lalu script untuk login dan melakukan command yang ada akan dinamakan **main.sh**.

## A
Kita diminta untuk membuat sebuah register, maka setelah pengguna membuka file **register.sh** maka akan langsung diminta untuk mengisi username dan password yang akan didaftarkan.
```bash
echo "Halo silahkan Register terlebih dahulu"
read -p "Username:" username
read -s -p "Password:" password
```
sebelum memasukkan data yang telah diinputkan ke dalam **./users/user.txt.** ,akan dilakukan pengecekan pada file **user.txt**.
```bash
unameexists=$(awk -F: -v user=$username '$1 == user {print $1}' ./users/user.txt)

if [[ "$unameexists" ]]
then
    echo -e "\nUser exists."
    echo "$(date +%m/%d/%Y_%T) REGISTER: ERROR User already exists" >> ./log.txt
    exit 1
```
kode diatas akan mengecek apakah username telah terdaftar di file **user.txt** menggunakan awk. Jika user telah terdaftar **user.txt** program akan mengirimkan log ke file **log.txt** berupa tanggal jam dan pesan log tersebut.

## B
Selanjutnya untuk masalah keamanan, input password pada login dan register harus tertutup/hidden. Untuk melakukan hidden pada input password bisa menggunakan options **-s**.
```bash
read -s -p "Password:" password
```
Selain password harus hidden, ada beberapa kriteria password yang harus dipatuhi. Berikut if else untuk mengecek beberapa kriteria yang harus dipatuhi.
```bash
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
else
    echo "Anda telah terdaftar sebagai User"
fi

echo $username:$password:"0":"0" >> ./users/user.txt
echo "$(date +%m/%d/%Y_%T) REGISTER: INFO User $username registered successfully" >> ./log.txt
```
Dapat dilihat dari kode diatas, jika semua kriteria password dipatuhi dan username tersedia, maka program akan menyimpan credentials dari user dan disimpan pada file **user.txt**. disitu terdapat **0:0** digunakan untuk mencatat record apakah user berhasil login atau tidak. Jika berhasil akan tercatat pada 0 yang pertama, dan jika gagal akan tercatat pada 0 yang kedua. 

Setelah menyimpan cretedtials user, program akan mengirimkan sebuah log yang memberi pesan bahwa user telah teregister.

## C
Selanjutnya kita diminta untuk mengirimkan sebuah log ke file **log.txt** dengan format : MM/DD/YY hh:mm:ss **MESSAGE**. Berikut adalah code yang digunakan untuk menyimpan log tersebut.

#### **register.sh** ####
* Ketika mencoba register dengan username yang sudah terdaftar, maka message pada log adalah REGISTER: ERROR User already exists
```bash
echo "$(date +%m/%d/%Y_%T) REGISTER: ERROR User already exists" >> ./log.txt
```
* Ketika percobaan register berhasil, maka message pada log adalah REGISTER: INFO User **USERNAME** registered successfully
```bash
echo "$(date +%m/%d/%Y_%T) REGISTER: INFO User $username registered successfully" >> ./log.txt
```
#### **main.sh** ####

* Ketika user mencoba login namun passwordnya salah, maka message pada log adalah LOGIN: ERROR Failed login attempt on user **USERNAME**
```bash
echo "$(date +%m/%d/%Y_%T) LOGIN: ERROR Failed login attempt on user $username" >> ./log.txt
```
* Ketika user berhasil login, maka message pada log adalah LOGIN: INFO User **USERNAME** logged in
```bash
echo "$(date +%m/%d/%Y_%T) LOGIN: INFO User $username logged in" >> ./log.txt
```

## D
Disini kita diminta untuk membuat dua command. Cara yang dapat digunakan adalah menggunakan case. Dengan menggunakan case, setelah pengguna menginputkan command yang diinginkan maka akan diarahkan ke program/command yang sesuai.

```bash
echo "Silahkan Masukkan Command eksekusi"
read -p "Command:" comm download

case $comm in
    dl)
        /*kode*/
    ;;
    att)
        /*kode*/
    ;;
    *)
        /*kode*/
    ;;
esac
```
Bisa dilihat pada kode diatas, jika pengguna memasukkan command yang sesuai maka akan menuju case yang dipilih. Terdapat 1 input lain selain **comm** yaitu download, untuk menyimpan variabel banyak download yang diinginkan pengguna. 

#### i
command pertama adalah **dl N** untuk mendownload gambar dari https://loremflickr.com/320/240, dengan **dl** adalah nama dari commandnya dan N adalah banyak file yang ingin di download.
```bash 
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
        /*kode*/
    ;;
    *)
        /*kode*/
    ;;
esac
```
Setelah pengguna memasukkan command **dl N**, maka akan masuk ke casenya. Pertama akan ada pengecekan untuk apakah sudah ada file zip yang dibuat dengan nama yang sama, jika terdapat file zip yang sama maka akan file zip tersebut akan di unzip dengan password. 

Selanjutnya program akan membuat folder dengan format jam. Hal ini perlu dilakukan karena jika terdapat file zip yang sudah ada maka otomatis pengguna tersebut telah menjalankan command itu sebelumnya, oleh karena itu perlu dibuat folder dengan format nama file **TIME_username** agar user dapat menjalankan command **dl** lebih dari sekali.

Selanjutnya akan masuk ke for loop, ini dimana program akan mendownload file sebanyak input yang dimasukkan pengguna dengan menggunakan **"wget"**. Dalam waktu yang bersamaan ketika mendownload, program akan merename file tersebut menjadi **"PIC_X"** dengan X adalah perulangan for loop atau banyaknya file yang telah didownload dan memindahkan file tersebut ke folder yang telah dibuat. Setelah selesai mendownload semua file yang diinginkan dan dipindahkan ke folder, selanjutnya akan dilakukan zip dengan password yang ada.

Jika pengecekan if tidak sesuai (tidak ada nama zip yang sama) maka proses yang dilakukan kurang lebih sama hanya saja tanpa unzip diawal.

#### ii 
Lalu ada command kedua yaitu **att** untuk Menghitung jumlah percobaan login baik yang berhasil maupun tidak dari user yang sedang login saat ini.
```bash 
case $comm in
    dl)
        /*kode*/
    ;;
    att)
        login=$(awk -F: -v user=$username '$1 == user {print $3}' ./users/user.txt)
        salah=$(awk -F: -v user=$username '$1 == user {print $4}' ./users/user.txt)
        echo -e "\nBerhasil login sebanyak: " $login
        echo -e "Gagal login sebanyak: " $salah

    ;;
    *)
        /*kode*/
    ;;
esac
```
Cara yang digunakan untuk menyimpan record login yang berhasil dan login yang gagal yaitu dengan menyiapkan field pada **user.txt** selain username dan password, yaitu angka untuk mencatat login berhasil dan gagal.
#### pada register.sh
```bash 
echo $username:$password:"0":"0" >> ./users/user.txt
```
Dapat dilihat pada kode diatas terdapat field **0:0** yang digenerate pada saat register. Selanjutnya untuk memasukkan record adalah ketika login berhasil atau login gagal dengan menggunakan gawk.
#### Berhasil Login
```bash
gawk -F: --include inplace -v user=$username  '$1 == user {$3=$3+1} 1' OFS=: ./users/user.txt
```
#### Gagal Login
```bash
gawk -F: --include inplace -v user=$username  '$1 == user {$4=$4+1} 1' OFS=: ./users/user.txt
```
Dari kode diatas bisa dilihat bahwa field yang awalnya berisi 0 tadi akan diincrement sebanyak satu jika berhasil/gagal login. Lalu untuk menampilkan field tersebut dapat menggunakan awk.



