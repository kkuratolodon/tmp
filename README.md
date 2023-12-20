# PageTurnMobile

## Nama Anggota Kelompok

- Muhammad Irfan Firmansyah
- Arya Kusuma Daniswara
- Fern Khairunnisha Adelia Aufar
- Irsyad Fadhilah
- Rifdah Nabilah Rahma
- Faiz Abdurrachman

## Deskripsi Aplikasi

Aplikasi mobile PageTurn merupakan perpustakaan digital yang memudahkan pengguna untuk mengakses ratusan e-book dalam satu platform, menghemat waktu dalam mencari dan mengelola buku-buku mereka. Pengguna dapat melihat homepage yang berisi rekomendasi buku berdasarkan banyak peminjaman dari buku tersebut. Terdapat pula katalog buku yang berisikan daftar semua buku beserta informasinya. Admin dapat menambahkan buku ke dalam katalog. Pengguna juga dapat merequest buku yang ingin ditambahkan. pengguna juga dapat melakukan peminjaman terhadap buku, dan mengembalikannya. Buku yang telah dipinjam dapat direview dan juga dilaporkan apabila terdapat kerusakan.

## Modul Aplikasi

### Daftar Modul
- Modul Authentikasi mengimplementasikan user dapat Register akun baru dan Login dengan akun yang sudah didaftarkan.
- Modul Homepage megimplementasikan sebuah halaman homepage yang menjadi landing page para user dan menampilkan koleksi buku favorit yang paling sering dipinjam : Faiz 
- Modul Katalog Buku yang mengimplementasikan informasi dari setiap buku (Nama buku, Penulis, Rating, Genre, Tahun terbit, dll) : Arya
- Modul Request Buku yang mengimplementasikan request buku yang ingin di pinjam namun tidak terdapat di katalog : Fern
- Modul Peminjaman Buku yang mengimplementasikan Buku yang ingin dipinjam atau dikembalikan : Irfan
- Modul Review/ulasan Buku yang mengimplementasikan review dari pembaca buku : Irsyad
- Modul Laporan buku rusak yang mengimplementasikan detail informasi buku yang rusak (nama buku dan alasan rusak) : Rifdah

### Peran Pengguna

1. **Pengguna yang Belum Login (Guest):** <br>
    - **Autentikasi:** <br/>
      Pengguna dapat melakukan login jika sudah memiliki akun untuk masuk ke aplikasi. Jika belum memiliki akun, pengguna dapat membuat akun baru dengan membuat username dan password sehingga dapat melakukan login untuk masuk ke aplikasi.

2. **Pengguna yang Sudah Login (Member):** <br>
    - **Homepage:** <br/>
      Member dapat melihat homepage yang berisi informasi terkait akun, dan juga button untuk mengakses ke fitur-fitur lainnya.
    - **Autentikasi:** <br>
      Member dapat melakukan logout dari aplikasi.
    - **Katalog Buku:** <br>
      Member dapat membuka katalog buku untuk melihat informasi dari buku-buku yang tersedia.
    - **Request Buku:** <br>
      Member dapat merequest buku yang akan ditambahkan sebagai wishlist jika buku tersebut belum tersedia.
    - **Peminjaman Buku:** <br>
      Member dapat melakukan peminjaman buku jika buku tersebut tersedia. Kemudian, member dapat mengembalikan buku tersebut jika sudah selesai dibaca.
    - **Review Buku:** <br>
      Member dapat melihat review-review dari suatu buku. Member juga dapat mereview buku yang mereka sudah selesai baca. 
    - **Koleksi Buku Favorit:** <br>
      Member dapat melihat koleksi buku-buku favorit.   
    - **Laporan buku rusak:** <br>
      Member dapat membuat laporan buku rusak, jika buku yang mereka pinjam rusak.

3. **Admin:** <br>
   Admin dapat membuka semua yang dapat dibuka oleh member. Tetapi, admin mempunyai satu peran tambahan:
     - **Katalog Buku:** <br>
       Admin dapat menambahkan buku baru ke dalam daftar buku.

### Alur Integrasi 
Alur Pengintegrasian dengan Web Service untuk Terhubung dengan Aplikasi Web yang Sudah dibuat saat Proyek Tengah Semester

1. Website yang telah terlebih dahulu dideploy disusun memiliki backend yang dapat menampilkan JSON data-data terkait
2. Membuat file bernama fetch.dart dalam utils folder untuk melakukan proses async mengambil data
3. fetch.dart dilengkapi dengan suatu fungsi yang dapat dipanggil dari luar file kemudian melakukan return data dalam suatu list
4. Fungsi di dalam fetch.dart mengandung url yang digunakan sebagai endpoint JSON
5. Pemanggilan fungsi dilakukan di widget terkait untuk diolah sesuai dengan kebutuhan


## Berita Acara
Link berita acara: https://docs.google.com/spreadsheets/d/14ZFo0cpXrDy6iEv0GsTosSeeLtI29T_vBQ87AqTEwMA/edit?usp=sharing
