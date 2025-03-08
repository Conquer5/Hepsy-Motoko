# Hepsy Backend

Hepsy adalah backend untuk aplikasi pelacakan mood dan konsultasi psikologi yang ditulis dalam bahasa [Motoko](https://github.com/dfinity/motoko). Proyek ini menyediakan berbagai fitur untuk mendukung kesehatan mental melalui pencatatan mood, posting anonim, event komunitas, konten interaktif, dan dukungan ChatBot berbasis pilihan.

## Fitur Utama

- **Mood Tracking:**  
  Mencatat dan mengelola riwayat mood pengguna dengan fungsi `MoodStatus` dan `MoodHistory`.

- **Admin Management:**  
  Menambahkan dan menghapus admin menggunakan `addAdmin` dan `removeAdmin`.

- **Posting Anonim:**  
  Pengguna dapat mengirim curhat secara anonim melalui `postAnonymous` dan mengaksesnya dengan `getUserAnonymousPosts` atau `getAnonymousPosts` (untuk admin).

- **Community Events:**  
  Menambahkan event komunitas dengan `addCommunityEvent` dan mengambil daftar event melalui `getCommunityEvents`.

- **Konten Interaktif:**  
  Menangani penambahan story (podcast) melalui `addStory` dan `Story`, serta menambahkan artikel dan memberikan rekomendasi artikel melalui `addArticle` dan `RecommendedArticles`.

- **Konsultasi Psikologi:**  
  Menjadwalkan, melihat, dan membatalkan konsultasi psikologi dengan `ScheduleConsultation`, `ViewConsultation`, dan `CancelConsultation`.

- **ChatBot Berbasis Pilihan:**  
  Menghasilkan respons dukungan berdasarkan opsi yang dipilih pengguna (misalnya, `#Stress`, `#Sad`, `#Happy`, `#Excited`, atau `#Default`) melalui `ChatBotChoice`.

- **Daily Reminder:**  
  Memberikan pengingat harian yang disesuaikan dengan mood terakhir pengguna melalui `DailyReminder`.

## Struktur Proyek

