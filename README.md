# KulinerLokal (Yogyakarta) - Aplikasi Mobile Rekomendasi & Direktori Kuliner

> **Tugas Pengembangan Aplikasi Mobile**  
> **Disusun oleh:** Daru Trifrediyanto (NIM: 5250411151)  
> **Program Studi:** Sarjana Informatika, Fakultas Sains dan Teknologi  
> **Institusi:** Universitas Teknologi Yogyakarta (2026)  

---

## 📱 Ringkasan Proyek

**KulinerLokal** adalah aplikasi mobile direktori dan rekomendasi kuliner otentik berbasis wilayah Yogyakarta. Aplikasi ini dirancang untuk mempermudah pengguna lokal maupun wisatawan dalam menemukan kuliner legendaris dan terdekat secara instan, lengkap dengan menu andalan, jam operasional, status buka/tutup, estimasi jarak, rating, hingga navigasi langsung menggunakan Google Maps.

---

## 🎨 Palet Desain & UI/UX

* **Tema Visual**: *Warm Terracotta & Spice Tones* (`#D35400`, `#E67E22`, `#F39C12`) yang memancarkan kehangatan budaya kuliner Nusantara dan menggugah selera.
* **Desain Sistem**: Material Design 3 yang responsif, bersih, dan *lightweight*.
* **Struktur Navigasi**:
  * **Top Header Global**: Foto profil avatar di sisi kiri dan penanda GPS lokasi aktif di sisi kanan.
  * **Bottom Navigation Bar**: Navigasi 3 tab utama (*Beranda*, *Kuliner*, *Favorit*).

---

## 🚀 Fitur Utama Sesuai Spesifikasi Dokumen Tugas

### 1. Layar Beranda (Home Screen)
* **Custom Greeting**: Ucapan selamat datang hangat dengan identitas pengguna (*"Sugeng Rawuh, Daru!"*).
* **Banner Carousel Highlight**: Kartu tempat kuliner terpopuler dan legendaris dengan badge penghargaan lokal (*Gudeg Yu Djum, Sate Klathak Pak Pong, Kopi Joss Lik Man*).
* **Filter Kategori Cepat**: Baris chip interaktif (*Warung Makan, Sate & Daging, Kedai Kopi & Angkringan, Jajanan Pasar, Mie Tradisional*).
* **Section Terdekat**: Rekomendasi kuliner dalam radius terdekat berdasarkan lokasi GPS aktif.

### 2. Layar Pencarian & Eksplorasi (Search & Explore Screen)
* **Interactive Real-Time Search Bar**: Pencarian cerdas berdasarkan nama makanan, tempat, menu, atau daerah.
* **Filter Chips Responsif**: Filter cepat satu ketukan (*Terdekat, Rating Tinggi 4.7+, Terjangkau, Buka Sekarang*).
* **Daftar Hasil Dinamis**: Kartu kuliner lengkap dengan indikator status Buka (hijau) / Tutup (merah), rating bintang, jarak, dan rentang harga.
* **Empty State**: Tampilan visual ramah saat hasil pencarian tidak ditemukan dengan tombol reset.

### 3. Layar Detail Kuliner (Detail Screen)
* **Hero Header Image**: Foto tempat kuliner resolusi optimal dengan tombol kembali dan tombol toggle favorit.
* **Informasi Esensial**: Kategori, rentang harga, jam operasional, rating bintang, dan jumlah ulasan.
* **Tombol Aksi Utama**: **"Petunjuk Arah (Google Maps)"** lebar dan menonjol yang langsung membuka rute lokasi via Intent / Google Maps.
* **Alamat Lengkap & Copy Address**: Tombol satu-klik untuk menyalin alamat lengkap ke clipboard.
* **Menu Andalan**: Foto, nama menu, deskripsi, dan harga per porsi.
* **Ulasan Pengunjung**: Testimoni ringkas pengunjung lokal.

### 4. Layar Favorit (Saved Bookmarks)
* **Penyimpanan Lokal Interaktif**: Daftar kuliner yang ditandai disimpan menggunakan State Management reaktif.
* **Filter Wilayah**: Penyaringan bookmark berdasarkan daerah (*Kota Yogyakarta, Bantul, Sleman*).
* **Aksi Cepat**: Tombol hapus dari favorit dengan konfirmasi SnackBar *Undo*.
* **Empty State Informatif**: Ilustrasi ramah dan tombol pemicu *"Jelajahi Kuliner"*.

### 5. Layar Profil Pengembang (Profile Screen)
* Menampilkan informasi mahasiswa, NIM, universitas, serta rincian spesifikasi aplikasi mobile.

---

## 🛠️ Arsitektur & Teknologi

* **Framework**: Flutter 3.x (Dart)
* **Arsitektur**: Clean Feature-First / Separation of Concerns
* **State Management**: Provider (`ChangeNotifier`)
* **Integrasi Peta**: `url_launcher` (membuka Google Maps app/web via koordinat lat/long)
* **Penyimpanan**: `shared_preferences`

---

## 📂 Struktur Direktori Proyek

```text
kuliner_lokal/
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart
    ├── core/
    │   ├── constants/
    │   │   ├── app_colors.dart
    │   │   └── app_text_styles.dart
    │   ├── theme/
    │   │   └── app_theme.dart
    │   └── utils/
    │       └── map_launcher.dart
    ├── models/
    │   ├── culinary_place.dart
    │   ├── menu_item.dart
    │   └── review_model.dart
    ├── data/
    │   └── mock_culinary_data.dart
    ├── providers/
    │   └── culinary_provider.dart
    ├── widgets/
    │   ├── top_app_header.dart
    │   ├── banner_carousel.dart
    │   ├── category_chip_bar.dart
    │   ├── filter_chip_bar.dart
    │   ├── culinary_card.dart
    │   └── empty_state.dart
    └── screens/
        ├── main_navigation_screen.dart
        ├── home/
        │   └── home_screen.dart
        ├── explore/
        │   └── explore_screen.dart
        ├── detail/
        │   └── detail_screen.dart
        ├── favorites/
        │   └── favorites_screen.dart
        └── profile/
            └── profile_screen.dart
```

---

## 💻 Cara Menjalankan Proyek

1. **Buka folder proyek di terminal / IDE (VS Code / Android Studio)**:
   ```bash
   cd kuliner_lokal
   ```
2. **Unduh dependencies paket**:
   ```bash
   flutter pub get
   ```
3. **Jalankan aplikasi (pada Emulator Android / Chrome / Perangkat HP Fisik)**:
   ```bash
   flutter run
   ```
