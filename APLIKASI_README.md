# 🌼 MindShelter

**Rumah Digital untuk Jiwa Bahagia dan Percaya Diri Anak Panti**

---

## 📱 Tentang Aplikasi

MindShelter adalah aplikasi digital berbasis mindfulness dan edukasi interaktif yang membantu anak panti asuhan mengembangkan kesehatan mental positif, rasa percaya diri, dan keterampilan sosial.

### 🎯 Tujuan Program
- Meningkatkan kesadaran dan kemampuan anak panti dalam mengenali serta mengelola emosi
- Mengurangi tingkat stres dan kecemasan melalui aktivitas mindfulness digital yang menyenangkan
- Membangun lingkungan panti yang suportif dan ramah kesehatan mental
- Melatih kemandirian dan kepercayaan diri melalui aktivitas kreatif berbasis aplikasi

### 👥 Target Pengguna
Anak-anak Panti Asuhan Titian Umat Muslim Gorontalo

---

## ✨ Fitur Utama

### 1. 🎧 Audio Mindfulness Ceria
- Audio relaksasi dan motivasi
- Cerita lokal Gorontalo yang menginspirasi
- Musik untuk tidur nyenyak
- Latihan pernapasan

### 2. 💬 Ruang Curhat Aman
- Forum untuk berbagi cerita
- Dukungan dari sesama teman
- Posting anonim tersedia
- Sistem komentar dan dukungan

### 3. 📱 Mood Tracker & Journal
- Catat emosi harian dengan emoji
- Tulis jurnal pribadi
- Lihat riwayat mood
- Analisis pola emosi

### 4. 🤖 Chatbot "Teman Hati"
- AI companion yang ramah
- Respon empati dan dukungan
- Saran menenangkan diri
- Tersedia 24/7

### 5. 🧩 Mini Games Self-Learning
- Tebak Emosi - Belajar mengenali emosi
- Puzzle Kebaikan - Nilai moral
- Fokus Bersama - Latihan konsentrasi
- Cerita Pilihanku - Pengambilan keputusan
- Berbagi Kasih - Empati

---

## 🛠️ Teknologi

### Framework & Language
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language

### Dependencies
- `google_fonts` - Typography
- `provider` - State management
- `intl` - Internationalization
- `font_awesome_flutter` - Icons
- `audioplayers` - Audio playback
- `shared_preferences` - Local storage
- `lottie` - Animations

---

## 📁 Struktur Folder

```
lib/
├── main.dart                 # Entry point aplikasi
├── data/
│   └── dummy_data.dart       # Data dummy untuk development
├── models/                   # Model data
│   ├── mood.dart
│   ├── journal.dart
│   ├── audio_mindfulness.dart
│   ├── chat_message.dart
│   ├── curhat_post.dart
│   └── mini_game.dart
├── screens/                  # Halaman aplikasi
│   ├── home_screen.dart
│   ├── mood_tracker_screen.dart
│   ├── audio_mindfulness_screen.dart
│   ├── curhat_screen.dart
│   ├── chatbot_screen.dart
│   └── mini_games_screen.dart
├── utils/                    # Utilities
│   ├── app_colors.dart
│   └── app_theme.dart
└── widgets/                  # Reusable widgets
```

---

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK (3.9.2 atau lebih baru)
- Android Studio / VS Code
- Android Emulator atau Physical Device

### Instalasi

1. Clone repository
```bash
git clone <repository-url>
cd mindfullshelter
```

2. Install dependencies
```bash
flutter pub get
```

3. Jalankan aplikasi
```bash
flutter run
```

---

## 📱 Build untuk Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (untuk Google Play)
```bash
flutter build appbundle --release
```

---

## 🎨 Desain & UI/UX

### Warna Utama
- **Primary**: Purple (#6B4CE6) - Kreativitas & Spiritualitas
- **Secondary**: Pink (#FF6B9D) - Kasih sayang & Empati
- **Accent**: Yellow (#FFC93C) - Kebahagiaan & Optimisme

### Warna Mood
- **Senang**: Kuning (#FFC93C)
- **Tenang**: Hijau (#6BCF7E)
- **Sedih**: Biru (#5B9BD5)
- **Marah**: Merah (#FF6B6B)
- **Cemas**: Ungu Muda (#B794F6)

### Typography
- Font Family: **Poppins** (Google Fonts)
- Friendly dan mudah dibaca untuk anak-anak

---

## 🔄 Status Development

### ✅ Sudah Selesai
- [x] Setup project structure
- [x] Implementasi theme & colors
- [x] Home screen dengan navigasi
- [x] Mood Tracker & Journal
- [x] Audio Mindfulness (UI & player dummy)
- [x] Ruang Curhat (forum)
- [x] Chatbot Teman Hati
- [x] Mini Games (list & detail)
- [x] Dummy data untuk semua fitur

### 🔜 Next Steps (Backend Integration)
- [ ] API integration untuk semua fitur
- [ ] User authentication
- [ ] Real-time chat untuk Ruang Curhat
- [ ] Audio streaming integration
- [ ] Push notifications
- [ ] Analytics & reporting
- [ ] Admin panel

---

## 👨‍💻 Tim Pelaksana

**Dosen Pembimbing**: Wiwit Zuriati Uno, S.Farm., M.Si

**Tim Mahasiswa**:
- Mahasiswa Psikologi - Desain modul mindfulness
- Mahasiswa Informatika - Developer aplikasi
- Mahasiswa Farmasi - Edukator kesehatan mental
- Mahasiswa Kesehatan Masyarakat - Evaluasi dampak

---

## 📄 License

Aplikasi ini dikembangkan untuk program pemberdayaan sosial dan kesehatan mental anak panti asuhan.

---

## 📞 Kontak

Untuk informasi lebih lanjut tentang program MindShelter, silakan hubungi:
- **Panti Asuhan Titian Umat Muslim Gorontalo**
- **Universitas Negeri Gorontalo**

---

**🌟 "MindShelter: Rumah Digital untuk Jiwa Bahagia dan Percaya Diri Anak Panti" 🌟**
