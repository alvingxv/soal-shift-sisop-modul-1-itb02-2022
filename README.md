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

## Kendala yang dihadapi
Terdapat kendala untuk menamai file jika telah terdapat nama file pic_01 atau pic_02 dst. lalu menamai sesuai lanjutan yang ada.

## Screenshot hasil soal 1
- Berhasil register

![1](https://user-images.githubusercontent.com/83297238/156564351-717a40ba-07b8-46df-a6c1-0874c3f9ed3c.png)
- Gagal register (user exist)

![2](https://user-images.githubusercontent.com/83297238/156564564-2e9fce41-3a5a-4dc4-a416-a68e62b945af.png)
- Gagal Login (Password salah)

![3](https://user-images.githubusercontent.com/83297238/156564639-cac303a5-b1b7-4506-acb8-42821d9fb145.png)
- Berhasil Login

![4](https://user-images.githubusercontent.com/83297238/156564793-e1022c64-d1cb-4948-a0ad-2498758da4a8.png)
- Hasil command **dl**

![5](https://user-images.githubusercontent.com/83297238/156564864-5e5e2266-0d7b-401b-a246-4df6697bf450.png)
- Hasil command **att**

![6](https://user-images.githubusercontent.com/83297238/156564923-a8845080-dee8-48a6-9823-1985879fee1a.png)
- Isi file log

![7](https://user-images.githubusercontent.com/83297238/156564980-a17cb9fc-612c-466c-926c-c4900d1b8179.png)

# Soal 2

Pada tanggal 22 Januari 2022, website https://daffa.info dihack oleh seseorang yang tidak bertanggung jawab. Sehingga hari sabtu yang seharusnya hari libur menjadi berantakan. Dapos langsung membuka log website dan menemukan banyak request yang berbahaya. Bantulah Dapos untuk membaca log website https://daffa.info Buatlah sebuah script awk bernama "soal2_forensic_dapos.sh" untuk melaksanakan tugas-tugas berikut:

A. Buat folder terlebih dahulu bernama forensic_log_website_daffainfo_log.

B. Dikarenakan serangan yang diluncurkan ke website https://daffa.info sangat banyak, Dapos ingin tahu berapa rata-rata request per jam yang dikirimkan penyerang ke website. Kemudian masukkan jumlah rata-ratanya ke dalam sebuah file bernama ratarata.txt ke dalam folder yang sudah dibuat sebelumnya.

C. Sepertinya penyerang ini menggunakan banyak IP saat melakukan serangan ke website https://daffa.info, Dapos ingin menampilkan IP yang paling banyak melakukan request ke server dan tampilkan berapa banyak request yang dikirimkan dengan IP tersebut. Masukkan outputnya kedalam file baru bernama result.txt kedalam folder yang sudah dibuat sebelumnya.

D. Beberapa request ada yang menggunakan user-agent ada yang tidak. Dari banyaknya request, berapa banyak requests yang menggunakan user-agent curl?
Kemudian masukkan berapa banyak requestnya kedalam file bernama result.txt yang telah dibuat sebelumnya.

E. Pada jam 2 pagi pada tanggal 22 terdapat serangan pada website, Dapos ingin mencari tahu daftar IP yang mengakses website pada jam tersebut. Kemudian masukkan daftar IP tersebut kedalam file bernama result.txt yang telah dibuat sebelumnya.

Agar Dapos tidak bingung saat membaca hasilnya, formatnya akan dibuat seperti ini:
* File ratarata.txt
Rata-rata serangan adalah sebanyak `rata_rata` requests per jam

* File result.txt
IP yang paling banyak mengakses server adalah: `ip_address` sebanyak `jumlah_request` requests
Ada `jumlah_req_curl` requests yang menggunakan curl sebagai user-agent
`IP Address Jam 2 pagi`
`IP Address Jam 2 pagi`
`dst`

*Gunakan AWK
** Nanti semua file-file HASIL SAJA yang akan dimasukkan ke dalam folder forensic_log_website_daffainfo_log

## Penjelasan Code Soal 2
---
Pada soal ini kita diminta untuk membaca log website https://daffainfo yang terkena serangan dengan bantuan AWK script. Script berisi AWK disimpan pada satu file bernama **soal2_forensic_dapos.sh**. 
## A
---
Membuat folder bernama "forensic_log_website_daffainfo_log" yang digunakan untuk menyimpan hasil dari soal nomor 2 yaitu `ratarata.txt` dan `result.txt`
```bash
mkdir forensic_log_website_daffainfo_log
```
## B
---
Kemudian dari log yang diberikan yaitu [**log_website_daffainfo.log**](https://drive.google.com/file/d/1_kTU-SBSGDepzDyk5SXzkSLvCNPLDcOY/view?usp=sharing) kita diminta untuk mencari rata-rata request per jam menggunakan AWK dalam file **soal2_forensic_dapos.sh** dan disimpan ke `ratarata.txt`
```bash
awk -F: '$3==$3{++jumlah} {tot[$3]++;} END {for (i in tot)count++; printf "Rata-rata serangan adalah sebanyak %d requests per jam\n", jumlah/count'} log_website_daffainfo.log >> ratarata.txt 

```
#### Cara Pengerjaan :
1. **-F:** digunakan untuk mengambil field tertentu pada log dengan pemisah "**:**"
2. Kemudian yang kita dapatkan adalah jam pada log nya, jam ini akan digunakan untuk mencari rata-ratanya
3. Selanjutnya akan dihitung **jumlah** untuk nilai jam yang ada dan apabila sama akan dilewati
4. Seluruh jumlah jam yang ada akan ditotal pada **tot** 
4. Hal ini akan terus berlanjut untuk sebanyak jamnya dan setiap iterasi dihitung 1 dengan **count++**
5. Lalu setelah didapat total jam dan countnya akan dibagi dan didapatkan rata-rata per jamnya
6. Hasil tersebut akan disimpan ke ratarata.txt

## C
---
Selanjutnya pada soal ini kita diminta untuk mendapatkan IP Address yang paling banyak melakukan request beserta banyaknya request yang dilakukan dan hasil akan disimpan ke `result.txt`
```bash
awk -F: '{print $1}' log_website_daffainfo.log | sort -n | uniq -c | sort -rn | head -n 1 | awk '{print "IP yang paling banyak mengakses server adalah: " $2 " sebanyak " $1 " requests"}' >> result.txt
```
#### Cara Pengerjaan:
1. Pertama kami ingin mengambil kolom pertama dari log yang berisi IP Address menggunakan **-F** untuk memisahkan juga dengan field lain
2. Berikutnya digunakan **sort -n** untuk menampilkan ip address secara berurutan berdasarkan secara ascending
3. Kemudian apabila IP Address ditemukan sama maka tidak akan dihitung baru namun ditambahkan ke angka yang sudah ada sehingga hanya dihitung untuk IP Address yang berbeda dengan **uniq -c**
4. Setelah itu baru **sort -rn** digunakan untuk membalik urutan atau reverse urutan dari yang terbanyak atau descending
5. Terakhir karena diminta hanya menampilkan request terbanyak maka kami menggunakan **head -n 1** agar yang tampil hanya baris pertama saja
6. Hasil tersebut akan disimpan ke result.txt
## D
---
Selanjutnya pada soal ini diminta untuk mencari banyak request dengan user-agent yang menggunakan curl dan hasil akan disimpan ke `result.txt`
```bash
awk -F: '{if ($9 ~ /curl/) jumlah++} END {printf "Ada %d requests yang menggunakan curl sebagai user-agent\n", jumlah'} log_website_daffainfo.log >> result.txt
```
#### Cara Pengerjaan :
1. Sesuai perintah kami akan mencari kata curl yang terdapat di kolom user-agent dengan kondisi **if**
2. Pada log, kolom user agent berada di field ke-9 dengan pemisah ":" sehingga diambil field ke 9 yang memiliki kata **curl**
3. Setelah itu apabila ditemukan kata **curl** hasilnya akan disimpan pada **jumlah** dan ditampilkan hingga habis
4. Hasil tersebut akan disimpan ke result.txt
## E
---
Pada soal ini akan dicari IP Address dari request yang terjadi pad ajam 2 pagi di tanggal 22 Februari dan hasil akan disimpan ke `result.txt`
```bash
awk -F: '{if ($2 ~ "22/Jan/2022" && $3 ~ /02/) print $1 " jam 2 pagi"'} log_website_daffainfo.log >> result.txt
```
#### Cara Pengerjaan :
1. Pada soal ini kami menggunakan kondisi **if** untuk mencari field yang mengandung tanggal dan jam pada soal
2. Jika pada field ke-2 pada log yang berisi tanggal ditemukan **22/Jan/2022** dan pada field ke-3 ditemukan jam **02** akan diprint field ke-1 atau IP Addressnya
3. Hasil tersebut akan disimpan ke result.txt

# Soal 3

Buatlah program monitoring resource pada komputer kalian. Cukup monitoring ram dan monitoring size suatu directory. Untuk ram gunakan command `free -m`. Untuk disk gunakan command `du -sh <target_path>`. Catat semua metrics yang didapatkan dari hasil `free -m`. Untuk hasil `du -sh <target_path>` catat size dari path directory tersebut. Untuk target_path yang akan dimonitor adalah /home/{user}/.

A. Masukkan semua metrics ke dalam suatu file log bernama metrics_{YmdHms}.log. {YmdHms} adalah waktu disaat file script bash kalian dijalankan.

B. Script untuk mencatat metrics diatas diharapkan dapat berjalan otomatis pada setiap menit.

C. Kemudian, buat satu script untuk membuat agregasi file log ke satuan jam. Script agregasi akan memiliki info dari file-file yang tergenerate tiap menit. Dalam hasil file agregasi tersebut, terdapat nilai minimum, maximum, dan rata-rata dari tiap-tiap metrics. File agregasi akan ditrigger untuk dijalankan setiap jam secara otomatis. Berikut contoh nama file hasil agregasi metrics_agg_2022013115.log dengan format metrics_agg_{YmdH}.log

D. Karena file log bersifat sensitif pastikan semua file log hanya dapat dibaca oleh user pemilik file.

## Penjelasan Code Soal 3
Dalam soal ini kita diminta untuk membuat sebuah script bernama **minute_log.sh** untuk mencatat metrics tiap menit dan buat outputnya dengan format **metrics_{YmdHms}.log** di directory log. Setelah itu, buat script bernama **aggregate_minutes_to_hourly_log.sh** untuk mengagregasi file log ke satuan jam dengan output berformat **metrics_agg_{YmdH}.log**.

## A
Kita diminta untuk membuat sebuah script bernama **minute_log.sh** dan output bernama **metrics_{YmdHms}.log** berisi data metrics yang diambil dari `free -m` untuk menghitung memory dan `du -sh /home/{user}/` untuk menghitung size directory.

- Data hasil dari `free -m` dan `du -sh`
![1](https://raw.githubusercontent.com/Satriokml/images/main/gambar_1.png)

### Mengambil data memory dan size directory
```bash
memory=$(free -m | awk '/^Mem/ {print $2","$3","$4","$5","$6","$7}')
swap=$(free -m | awk '/^Swap/ {print $2","$3","$4}')
```
Kode diatas digunakan untuk mengambil data dari `free -m` yang berisi data dari memory komputer. Awk menggunakan pipe untuk mengambil data dari `free -m`, dan '^Mem' akan membaca baris yang memiliki kata-kata "Mem", begitu juga dengan  "^Swap". Tanda Dollar digunakan untuk menentukan data mana yang akan di ambil berdasarkan kolom. Misalkan kita mengetik  "$2", maka script akan mengambil data dari kolom 2. Data tersebut kemudian di masukkan ke dalam variabel yang bernama "memory" dan "swap".

```bash
path=$(du -sh /home/{user}/ | awk '{print $2","$1}')
namafile="metrics_$(date +"%Y%m%d%I%M%S").log"
```
Kode diatas berguna untuk mengambil ukuran dari directory yang ditentukan. Awk akan menggunakan pipe untuk mengambil data dari `du -sh` dan print kolom ke 2 dan ke 1. Kemudian data tersebut akan dimasukkan ke variabel "path". Selanjutnya adalah menentukan tujuan dari output script ini. Seperti format yang diminta di soal, file output dari script ini bernama "**metrics_{YmdHms}.log**" yang berisi Year(%Y), Month(%m), Date(%d), Hour(%I), Minute(M), dan Seconds(%S). Disini menggunakan Date Command untuk menanmpilkan format waktu. Selanjutya adalah memasukkan format file terebut ke dalam variabel yang bernama "namafile".

### Mengatur output
```bash
echo "$memory,$swap,$path" >> /home/{user}/log/$namafile
```
Disini script ini akan mengeprint atau mengecho variabel "memory", "swap", dan "path", kemudian akan disimpan di directory /home/{user}/log/ dengan format nama sesuai dengan variabel "namafile".

- Screenshot hasil output dari script "**minute_log.sh**"
![2](https://raw.githubusercontent.com/Satriokml/images/main/gambar_2.png)

## B
Disoal ini, kita diminta untuk dapat menjalankan scriptnya secara otomatis setiap menit. Disini kita akan menggunakan cronjob untuk membuat script ini berjalan setiap menit.
```
* * * * * /{user}/soal-shift-sisop-modul-1-itb02-2022/soal3/minute_log.sh >> /home/{user}/log/metrics.log 2>&1
``` 
Disini menggunakan kode `* * * * *` yang berarti script akan berjalan di setiap menit dan output akan di save di direktori "/home/{}/log/". "metrics.log" digunakan sebagai tujuan disini karena cronjob tidak akan berjalan tanpa tujuan file yang jelas. Maka dari itu, akan ditambahkan kode untuk menghapus file "metrics_log" pada script "**minute_log.sh**". Kodenya dapat dilihat di bawah ini.
```bash
cd /home/{user}/log/
rm metrics.log
```
## C
Disoal ini kita diminta untuk mengambil data dari semua log metrics yang telah dibuat oleh "**minute_log.sh**" setiap menit dan mengolah datanya untuk mendapat average, minimum, dan maximum dari seluruh metrics yang dibuat satu jam sebelumnya. Script ini diminta untuk berjalan secara otomatis setiap jam, dan akan disimpan di direktori log dengan format "**metrics_agg_{YmdH}.log**".

### Mengatur nama file dan membuat tmp
Pada bagian ini, kita akan mengatur nama format file yang akan dijadikan sebagai output, dan membuat file tmp untuk mencatat dan melakukan perhitungan.

```bash
cd /home/{user}/log
tmp=tmp_$(date +\%Y\%m\%d\%H\%M\%S).log
cat metrics_2022* > $tmp
namafile=metrics_agg_$(date +\%Y\%m\%d\%H).log
```
Pertama-tama kita harus mengganti direktori ke "/home/{user}/log" untuk menentukan tujuan untuk menyimpan file. Selanjutnya buat variabel tmp untuk menyimpan data seluruh metrics satu jam sebelumnya, file tmp ini juga dilakukan untuk menghitung average, minimum, dan maximum pada langkah selanjutnya. Script akan menginput seluruh file metrics yang pada soal sebelumnya sudah dibuat tiap menitnya dan menyimpannya ke file tmp.
- Screnshoot file tmp
![3](https://raw.githubusercontent.com/Satriokml/images/main/gambar_3.png)

 Kemudian akan dibuat variabel "namafile" yang berisi nama file output dari script ini sesuai dengan format yang diminta yaitu "**metrics_agg_$(date +\%Y\%m\%d\%H)**" (Year(%Y), month(%m), date(%d), dan Hour(%H)).

### Menghitung Average
Pada bagian ini, kita diminta untuk menghitung average dari seluruh data yang telah didapatkan.

```bash
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
```
Kode diatas digunakan untuk mencari total dari data-data yang disimpan di tmp. Awk -F yang berarti "Field Separator" berguna untuk memisahkan string yang diprint di tmp. Selanjutnya adalah menghitung total nilai dari data-data yang ada di tmp dan jumlah dari datanya. Contohnya adalah `mem_total += $1`, kode tersebut akan menjumlahkan data yang ada pada kolom 1($1) dimana data yang ada di kolom 1 merupakan data total memory. Kode tersebut juga dapat berarti `mem_total = mem_total + $1`. Kode tersebut akan dijalankan juga pada data lainnya seperti "used memory", "free memory", dan seterusnya, kecuali pada variabel "path", karena path merupakan alamat direktori yang tidak berubah. 

Ketika semua data telah dihitung, variabel count akan increment untuk mencari jumlah datanya. Ketika semua data sudah dibaca, maka perhitungan akan diakhiri. Cara menghitung averagenya adalah dengan membagi total nilai data dengan jumlah seluruh datanya. Contohnya adalah `mem_total/count`, akan membagi total memory yang didapatkan dari perhitungan sebelumnya dengan jumlah total data yang dihitung. Kemudian hasil dari perhitungan tersebut akan tersimpan di file yang formatnya sudah tersimpan di variabel "namafile".

### Menghitung nilai minimum dan maximum
Pada bagian ini, kita akan menghitung nilai terkecil(minimum) dan terbesar(maskimum) dari data yang telah tersimpan di tmp.

```bash
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
```
Kode diatas berguna untuk menghitung nilai minimum dan maksimum dengan cara menyorting secara ascending dan mengambil headnya untuk mendapatkan minimumnya, dan menyorting data secara descending dan mengambil headnya untuk mencari nilai maksimum. Contohnya adalah : 
```bash
mem_total_min=$(awk -F, '{print $1}' $tmp | sort -n | head -n 1 | awk '{print $1}')
```
Pertama-tama, kita akan menggunakan field separator untuk memsisahkan data-data agar dapat diproses. Selanjutnya, kita akan print kolom 1($1) yang berisi data total memory yang berasal dari tmp. Kemudian data tersebut akan disort secara ascending dan akan diambil data pertama dari atas(`head -n 1`). Kemudian data tersebut akan tersimpan ke variabel "mem_total_min". Selanjtunya adalah :
  ```bash
mem_total_max=$(awk -F, '{print $1}' $tmp | sort -nr | head -n 1 | awk '{print $1}')
   ```
Kode tersebut memiliki cara kerja yang hampir sama dengan kode sebelumnya, bedanya adalah pada kode ini digunakan cara sorting descending dimana nilai terbesarnya akan berada di paling atas atau berada di "head". Kemudian nilai terbesarnya akan tersimpan di variabel "mem_total_max". Perhitungan ini akan diberlakuklan ke semua data (kecuali path yang berisi alamat direktori) untuk mencari nilai maksimum dan minimum masing-masing.

### Output nilai minimum, maksimum, dan menghapus file temporary
Pada bagian ini, kita akan meng-echo semua variabel yang berisi hasil hitungan yang telah dilakukan sebelumnya.
```bash
echo "minimum $mem_total_min,$mem_used_min,$mem_free_min,$mem_shared_min,$mem_buff_min,$mem_available_min,$swap_total_min,$swap_used_min,$swap_free_min,$path,$path_size_min" >> $namafile
echo "maximum $mem_total_max,$mem_used_max,$mem_free_max,$mem_shared_max,$mem_buff_max,$mem_available_max,$swap_total_max,$swap_used_max,$swap_free_max,$path,$path_size_max" >> $namafile
rm "$tmp"
```
Seluruh hasilnya akan disimpan di file yang alamatnya tersimpan di variabel nama file. Setelah semua proses selesai, kita akan menghapus file temporary yang kita gunakan untuk mencatat dan menghitung dengan command `rm file`.

- Screenshot hasil dari output "**aggregate_minutes_to_hourly_log.sh**"
![4](https://raw.githubusercontent.com/Satriokml/images/main/gambar_4.png)

### Menjalankan file secara otomatis
Untuk menjalankan file otomatis, kita akan menggunakan cronjob.
```
*/60 * * * * /{user}/soal-shift-sisop-modul-1-itb02-2022/soal3/aggregate_minutes_to_hourly_log.sh >> /home/{user}/log/metrics.log 2>&1
```
Disini menggunakan kode `*/60 * * * *` yang berarti script akan berjalan di setiap 60 menit / 1 jam dan output akan di save di direktori "/home/{}/log/". "metrics.log" digunakan sebagai tujuan disini karena cronjob tidak akan berjalan tanpa tujuan file yang jelas.

## D
Disoal ini, kita diminta untuk mengganti perizinan dan pemilik dari semua file log agar hanya user yang dapat membaca file log tersebut.
```bash
chown {user} metrics_2*
chmod 400 metrics_2*
```
Command `chown` akan mengganti kepemilikan file yang mempunyai nama awalan "metrics_2"(file yang dihasilkan tiap menit oleh "**minute_log.sh**"). Sedangkan command `chmod` akan memodifikasi file yang mempunyai nama awalan "metrics_2". Disini tertulis "400" yang berarti pemilik file bisa membaca file (4), grup tidak bisa membaca, menulis, dan mengexecute file (0), dan user lain tidak bisa membaca, menulis, dan mengexecute file (0). Kode diatas ditambahkan ke file "**minute_log.sh**". Untuk file "**aggregate_minutes_to_hourly_log.sh**", tambahan kode dibawah ini :
```bash
chown {user} $namafile
chmod 400 $namafile
```
Perbedaannya dengan kode diatas adalah hanya dalam penamaan file yang harus dimodifikasi.

- Screenshot permission dari file log
![5](https://raw.githubusercontent.com/Satriokml/images/main/gambar_5.png)

## Kendala yang dihadapi
- Bingung cara mengambil file metrics permenit untuk dihitung di aggregasi.
- Bingung cara mengaktifkan cronjob.
