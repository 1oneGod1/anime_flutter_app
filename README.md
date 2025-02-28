## Deskripsi:
Anime Flutter App adalah aplikasi yang menampilkan daftar anime dari API Jikan (MyAnimeList). Aplikasi ini memungkinkan pengguna untuk melihat daftar anime populer, anime yang akan datang, dan anime musiman. Selain itu, pengguna dapat menandai anime favorit, memfilter berdasarkan genre, dan menyimpan daftar favorit secara permanen menggunakan SharedPreferences.

## Fitur Utama:
•	Mengambil data anime dari API Jikan (Popular, Upcoming, Seasonal)
•	Menampilkan daftar anime dalam UI yang menarik
•	Melihat detail anime lengkap dengan sinopsis dan gambar
•	Menambahkan/menghapus anime dari daftar favorit
•	Menyimpan daftar favorit secara permanen menggunakan SharedPreferences
•	Filter berdasarkan genre anime
•	Navigasi menggunakan TabBar dan Dropdown untuk filter

## API yang Digunakan
Aplikasi ini mengambil data dari Jikan API, API publik dari MyAnimeList. Endpoints yang Digunakan:
•	Anime Populer : https://api.jikan.moe/v4/top/anime 
•	Anime yang Akan Datang : https://api.jikan.moe/v4/seasons/upcoming 
•	Anime Musiman (Seasonal) : https://api.jikan.moe/v4/seasons/now 

## Untuk menggunakan kode dalam konteks pemrograman Dart, berikut adalah langkah-langkah yang bisa diikuti:
1.	Mempersiapkan Lingkungan Pengembangan
o	Menggunakan dartpad yang bisa diakses melalui https://dartpad.dev/ 
2.	Tulis Kode Dart
o	Copy code yang ada ”main.dart” pada github : https://github.com/1oneGod1/anime_flutter_app 
3.	Jalankan kode Dart dengan klik Run

## Penjelasan Fitur
**Mengambil Data Anime Secara Asynchronous**
o	Menggunakan http package untuk melakukan request API.
o	Menggunakan Future.wait untuk mengambil beberapa kategori anime sekaligus.
**Menyimpan Anime Favorit Secara Permanen**
o	Menggunakan SharedPreferences untuk menyimpan daftar favorit, sehingga tetap ada meskipun aplikasi ditutup.
**Tampilan UI**
o	ListView → Untuk menampilkan daftar anime.
o	TabBar & TabBarView → Untuk berpindah antar kategori.
o	DropdownButton → Untuk memilih genre anime yang ingin difilter.
**Penanganan Error**
o	Menggunakan try-catch untuk menangani error saat mengambil data API.
o	Menampilkan pesan error dengan ScaffoldMessenger jika gagal mengambil data.

## Dokumentasi Code
![image](https://github.com/user-attachments/assets/30940ec0-c620-4a58-80c9-a7fdbe100474)
Kode ini adalah sebuah model Anime dalam bahasa Dart yang digunakan untuk merepresentasikan data anime yang diambil dari API Jikan (MyAnimeList). Model ini memiliki atribut id, title (judul anime), imageUrl (URL gambar anime), synopsis (deskripsi anime), dan genres (daftar genre dalam bentuk list string). Kelas ini memiliki constructor untuk menginisialisasi objek anime. Selain itu, terdapat factory method fromJson yang digunakan untuk mengonversi data JSON dari API menjadi objek Anime, dengan pengecekan apabila synopsis tidak tersedia maka akan diisi dengan teks default "No description available.". Pada bagian genres, JSON yang berupa list akan di-mapping menjadi daftar string. Kode ini juga memiliki method toJson, yang digunakan untuk mengubah objek Anime kembali menjadi format JSON, sehingga bisa disimpan dalam SharedPreferences atau dikirim ke server. Fungsi ini memastikan bahwa data tetap terstruktur dengan baik saat diambil dari atau disimpan ke dalam penyimpanan lokal.

![image](https://github.com/user-attachments/assets/445ce67f-37ad-474d-86da-e2949bbf2dec)
Kode ini merupakan bagian utama dari aplikasi Flutter yang menangani pengambilan data anime dari API dan pengelolaan state menggunakan StatefulWidget. Fungsi main() digunakan untuk menjalankan aplikasi dengan runApp(const AnimeApp()), di mana AnimeApp adalah StatefulWidget yang memiliki State bernama _AnimeAppState.
Di dalam _AnimeAppState, terdapat beberapa list data seperti popularAnime, upcomingAnime, seasonalAnime, dan favoriteAnime, yang digunakan untuk menyimpan daftar anime berdasarkan kategori. Selain itu, terdapat variabel selectedGenre yang digunakan untuk menyaring anime berdasarkan genre dengan nilai awal "All".
Pada metode initState(), dua fungsi dipanggil secara otomatis saat aplikasi dijalankan:
1.	fetchAnime() → Mengambil data anime dari API Jikan secara asynchronous.
2.	loadFavorites() → Memuat daftar anime favorit yang telah disimpan sebelumnya dari local storage (SharedPreferences).
Fungsi fetchAnime() bekerja dengan mengambil data dari tiga endpoint API (popular, upcoming, seasonal). Untuk mengoptimalkan prosesnya, digunakan Future.wait() yang memungkinkan multiple API calls dijalankan secara paralel. Jika semua request berhasil (status kode 200), maka data yang diterima dari API diubah menjadi list objek Anime menggunakan Anime.fromJson(), lalu disimpan ke dalam state aplikasi menggunakan setState() agar UI diperbarui secara otomatis.
Jika terjadi kesalahan saat mengambil data dari API, kode ini menangani error menggunakan try-catch, sehingga aplikasi tidak crash dan dapat menampilkan pesan error kepada pengguna.

![image](https://github.com/user-attachments/assets/0250f2f9-0d92-4564-90cd-6d913427dc2f)
Kode ini berfokus pada pengelolaan daftar anime favorit menggunakan SharedPreferences, serta fitur penyaringan anime berdasarkan genre. Fungsi loadFavorites() bertugas untuk memuat daftar anime favorit dari penyimpanan lokal (SharedPreferences). Data disimpan dalam bentuk string list JSON, sehingga perlu dikonversi kembali menjadi objek Anime menggunakan jsonDecode() dan Anime.fromJson(), lalu dimasukkan ke dalam list favoriteAnime.
Fungsi saveFavorites() digunakan untuk menyimpan daftar anime favorit ke SharedPreferences. Proses ini dilakukan dengan mengonversi setiap objek Anime ke format JSON menggunakan toJson(), lalu disimpan dalam list String menggunakan jsonEncode().Fungsi toggleFavorite(Anime anime) digunakan untuk menambahkan atau menghapus anime dari daftar favorit. Jika anime sudah ada di dalam daftar (favoriteAnime), maka akan dihapus dengan removeWhere(). Jika belum ada, anime akan ditambahkan ke dalam list. Setelah perubahan dilakukan dengan setState(), daftar favorit langsung disimpan ke SharedPreferences dengan memanggil saveFavorites().
Fungsi getFilteredAnime() digunakan untuk memfilter anime berdasarkan genre yang dipilih pengguna. Jika selectedGenre bernilai "All", maka semua anime akan ditampilkan tanpa filter. Jika tidak, maka hanya anime yang memiliki genre yang sesuai (anime.genres.contains(selectedGenre)) yang akan ditampilkan. Terakhir, dalam metode build(), aplikasi dibuat menggunakan MaterialApp dengan Scaffold sebagai struktur utama, serta AppBar sebagai judul halaman utama aplikasi.

![image](https://github.com/user-attachments/assets/e8400bfc-d950-4452-a1b3-00aad9d546d3)
Kode ini bertanggung jawab untuk menampilkan daftar anime berdasarkan kategori yang dipilih menggunakan TabBarView, yang mencakup anime populer, yang akan datang, musiman, dan favorit. Setiap kategori menggunakan widget AnimeList, yang berfungsi untuk menampilkan daftar anime dalam bentuk ListView. Widget ini menerima tiga parameter utama: animes (data anime yang ditampilkan), onFavorite (fungsi untuk menambah atau menghapus anime dari favorit), dan favorites (daftar anime yang telah ditandai sebagai favorit). Dengan pendekatan ini, kode menjadi lebih modular dan terorganisir, sehingga tampilan dan logika data terpisah dengan baik.

![image](https://github.com/user-attachments/assets/e8937f45-516c-4140-99be-e2b95df7d83d)
Kode ini berfungsi untuk menampilkan daftar anime dalam bentuk ListView dan memberikan tampilan detail anime saat item diklik. Jika data anime belum tersedia, maka akan ditampilkan CircularProgressIndicator sebagai indikator loading. Setiap item anime ditampilkan menggunakan ListTile, yang berisi gambar, judul, dan genre anime. Terdapat IconButton untuk menandai anime sebagai favorit, di mana ikon berubah antara ikon hati kosong dan hati merah tergantung apakah anime sudah masuk ke daftar favorit atau belum. Saat pengguna mengklik item anime, aplikasi akan berpindah ke halaman AnimeDetail menggunakan Navigator.push(). AnimeDetail adalah widget yang menampilkan informasi lengkap tentang anime dalam Scaffold, dengan judul anime di dalam AppBar berwarna merah.


##  Aplikasi (UI Preview)
![image](https://github.com/user-attachments/assets/0557bf8f-d982-4705-aa86-c0bacf3bea1e)![image](https://github.com/user-attachments/assets/f5f0a19c-3b25-438a-a193-ea6eaa613d19)![image](https://github.com/user-attachments/assets/668ce3a0-3d1e-47d1-8e09-b7ae91ec8909)![image](https://github.com/user-attachments/assets/e575c844-3dd5-4721-ab4a-80b52be183a1)

Gambar ini menunjukkan tampilan aplikasi Anime Flutter App yang telah berhasil dijalankan. Aplikasi ini menampilkan daftar anime berdasarkan kategori yang dipilih melalui TabBar di bagian atas, yaitu Popular, Upcoming, Seasonal, dan Favorites. Saat ini, tab Popular sedang aktif, dengan daftar anime yang dapat difilter berdasarkan genre menggunakan dropdown, yang saat ini disetel ke Comedy. Setiap anime ditampilkan dengan gambar, judul, dan daftar genre dalam bentuk ListView. Pengguna dapat menandai anime sebagai favorit dengan menekan ikon hati di sebelah kanan. Jika anime sudah masuk dalam daftar favorit, ikon hati akan berubah menjadi berwarna merah, seperti yang terlihat pada "Gintama: The Final".





