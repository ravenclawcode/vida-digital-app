# 🔧 TROUBLESHOOTING - VIDA Digital APK

## ❌ Masalah: App Force Close saat Dibuka

### Penyebab yang Sudah Diperbaiki:

1. **Error Handling tidak ada** ✅ FIXED
   - Tambahkan try-catch di main.dart
   - Tambahkan error handling untuk date formatting

2. **Missing Permissions** ✅ FIXED  
   - Tambahkan INTERNET permission
   - Tambahkan ACCESS_NETWORK_STATE permission

3. **Icon/Logo Error** ✅ FIXED
   - Fallback ke icon Material (heart icon) jika gambar tidak load
   - Container wrapper untuk prevent layout crash

4. **Orientation Lock** ✅ FIXED
   - Lock ke portrait mode untuk mencegah layout issue

---

## 🚀 Cara Install APK yang Benar:

### Di HP Android:

1. **Uninstall versi lama** (jika ada):
   - Settings → Apps → VIDA Digital → Uninstall
   - Atau long-press icon → Uninstall

2. **Clear cache** (jika perlu):
   - Settings → Storage → Clear cache

3. **Enable Unknown Sources**:
   - Settings → Security → Install unknown apps
   - Pilih app yang digunakan untuk install (Chrome/Files)
   - Enable "Allow from this source"

4. **Install APK baru**:
   - Download file `app-release.apk`
   - Tap file APK
   - Tap "Install"
   - Tunggu hingga selesai
   - Tap "Open"

---

## 📱 Minimum Requirements:

- Android 5.0 (Lollipop) atau lebih tinggi
- RAM minimal 2GB
- Storage minimal 100MB free space
- Internet connection (untuk Google Fonts)

---

## 🐛 Jika Masih Crash:

### Cek Logs:
Hubungkan HP ke PC dan jalankan:
```bash
adb logcat | findstr "Flutter"
```

### Atau jalankan dari Flutter:
```bash
flutter run --release
```

### Common Issues:

**1. "App not installed"**
- Uninstall versi lama dulu
- Pastikan storage cukup

**2. "Parse error"**
- APK corrupt, download ulang
- Pastikan download selesai 100%

**3. Black screen lalu crash**
- Restart HP
- Clear app data & cache
- Reinstall

**4. "This app is built for older Android version"**
- HP terlalu lama (Android < 5.0)
- Perlu update OS atau ganti HP

---

## ✅ Verifikasi APK Berhasil:

Setelah install, cek:
- [ ] App icon muncul di home screen
- [ ] Nama app: "VIDA Digital"
- [ ] App terbuka tanpa crash
- [ ] Home screen tampil dengan welcome card pink
- [ ] 6 fitur cards tampil (Audio, Chat, Mood, Chatbot, Edukasi, Komunitas)
- [ ] Bottom navigation berfungsi

---

## 📞 Contact Developer:

Jika masih ada masalah, hubungi developer dengan info:
- Model HP
- Versi Android
- Screenshot error (jika ada)
- Langkah yang sudah dicoba

---

**Last Updated:** November 18, 2025
**App Version:** 1.0.0
**Package:** com.ravenclawcode.vida
