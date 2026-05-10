# Kriteria Fitur TV Series
Terdapat beberapa kriteria utama yang harus Anda penuhi dalam membuat fitur TV Series movie_app.

## Kriteria 1: Daftar TV Series
Aplikasi harus menampilkan daftar TV Series populer, top rated, dan yang sedang tayang.
- Menampilkan TV series populer, top rated, dan sedang tayang pada satu halaman utama. (Anda boleh menampilkan pada halaman utama yang sudah ada atau membuat halaman baru).
- Menampilkan daftar TV series populer, top rated, dan sedang tayang masing-masing pada satu halaman sendiri.

## Kriteria 2: Detail TV Series

Aplikasi harus menampilkan detail TV Series berdasarkan item yang dipilih.
- Halaman detail menampilkan poster, judul, rating, dan sinopsis.
- Halaman detail menampilkan rekomendasi TV series lainnya.

## Kriteria 3: Pencarian TV Series
Terdapat fitur untuk mencari judul TV Series.
- Fitur pencarian berdasarkan judul dengan memanfaatkan API (bukan filtering secara lokal).
## Kriteria 4: Watchlist
Menambahkan daftar TV series yang ingin movie_app ke dalam suatu daftar yang disimpan secara lokal. Daftar watchlist harus tetap bertahan meskipun aplikasi ditutup dan dibuka kembali.
## Kriteria 5: Menerapkan Automated Testing
Fitur yang dikembangkan harus memiliki unit testing dengan minimal testing coverage 70%.
Untuk mengetahui testing coverage aplikasi, Anda dapat mengikuti langkah pada tautan berikut: https://stackoverflow.com/a/53663093

## Kriteria 6: Menerapkan Clean Architecture
Aplikasi wajib menerapkan clean architecture dan membagi source code menjadi 3 layer, yaitu:
- Domain : Berisi kebutuhan dan logika utama terkait kebutuhan bisnis & aplikasi
- Data : Berisi implementasi kode untuk mendapatkan data dari sumber eksternal.
- Presentation : Berisi implementasi widget dan tampilan aplikasi serta state management.
## Kriteria Opsional
Selain kriteria utama, terdapat beberapa kriteria opsional yang dapat Anda penuhi agar mendapat nilai yang lebih baik.

###  Menampilkan Informasi Season & Episode
Halaman detail tidak hanya menampilkan informasi umum terkait series, tetapi juga informasi mengenai season dan episodenya.

### Menambahkan Widget & Integration Test
Unit test hanyalah sebagian dari automated testing. Untuk memastikan aplikasi benar-benar teruji dengan baik, Anda bisa menambahkan widget test untuk memverifikasi tampilan dan integration test untuk menguji jalannya aplikasi secara keseluruhan.

## Kriteria Penilaian Submission
Submission Anda akan dinilai oleh reviewer untuk menentukan nilai submission yang Anda kerjakan.

Submission Anda akan dinilai oleh reviewer dengan skala 1-5. Untuk mendapatkan nilai tinggi, Anda bisa menerapkan beberapa saran berikut:
- Menyelesaikan kriteria opsional, yaitu season & episode.
- Menambahkan Widget dan integration test untuk menguji aplikasi.
- Menerapkan >95% test coverage.
- Menuliskan kode dengan bersih, mudah dibaca, dan memenuhi code convention Dart.


Berikut adalah detail penilaian submission:

Bintang 1 : Semua ketentuan wajib terpenuhi, namun terdapat indikasi kecurangan dalam mengerjakan submission.
Bintang 2 : Semua ketentuan wajib terpenuhi, tetapi terdapat kekurangan pada penulisan kode.
Bintang 3 : Semua ketentuan wajib terpenuhi, tetapi tidak ada improvisasi atau persyaratan opsional yang dipenuhi.
Bintang 4 : Semua ketentuan wajib terpenuhi dan menerapkan minimal satu saran di atas.
Bintang 5 : Semua ketentuan wajib terpenuhi dan menerapkan seluruh saran di atas.


## Ketentuan Berkas Submission
Berkas submission yang dikirim merupakan folder proyek movie_app dalam bentuk ZIP. 
Pastikan Anda hapus dulu folder build pada folder proyek sebelum mengkompresi dalam bentuk ZIP.
Jika ukuran berkas Zip > 25MB, Anda dapat mengupload projek Flutter Anda ke dalam GitHub terlebih dahulu, kemudian unduh projek tersebut as Zip.


## Submission akan ditolak bila
Kriteria wajib tidak terpenuhi.
Ketentuan berkas submission tidak terpenuhi.
Proyek yang Anda kirim tidak dapat dijalankan dengan baik.
Aplikasi mengalami eror.
Menggunakan bahasa pemrograman dan teknologi selain Flutter.
Melakukan kecurangan seperti tindakan plagiarisme.
Tidak menggunakan versi Flutter yang terbaru.