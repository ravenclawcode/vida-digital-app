import 'package:flutter/foundation.dart';
import 'package:mindfullshelter/models/terms_conditions_model.dart';

class TermsAndConditionsProvider with ChangeNotifier {
  final Map<TermsType, TermsAndConditions> _termsData = {
    TermsType.termsofService: TermsAndConditions(
      id: 'tos_1',
      type: TermsType.termsofService,
      lastUpdated: DateTime(2026, 02, 21),
      clauses: [
        Clause(
          title: '1. Penerimaan Ketentuan',
          description:
              'Dengan mengakses dan menggunakan aplikasi VIDA Digital, Anda menyetujui untuk terikat oleh syarat dan ketentuan ini. Jika Anda tidak menyetujui salah satu bagian dari ketentuan ini, Anda dilarang menggunakan layanan kami.',
        ),
        Clause(
          title: '2. Akun Pengguna',
          description:
              'Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda. VIDA Digital tidak bertanggung jawab atas kerugian yang timbul akibat penggunaan akun Anda oleh pihak ketiga tanpa izin.',
        ),
        Clause(
          title: '3. Batasan Layanan',
          description:
              'VIDA Digital berhak untuk mengubah, menghentikan, atau membatasi bagian mana pun dari layanan kami kapan saja tanpa pemberitahuan sebelumnya demi meningkatkan kualitas layanan atau alasan keamanan.',
        ),
      ],
    ),
    TermsType.privacyPolicy: TermsAndConditions(
      id: 'pp_1',
      type: TermsType.privacyPolicy,
      lastUpdated: DateTime(2026, 02, 21),
      clauses: [
        Clause(
          title: '1. Pengumpulan Informasi',
          description:
              'Kami mengumpulkan informasi yang Anda berikan secara langsung saat mendaftar, termasuk nama, alamat email, dan data profil untuk memberikan pengalaman layanan yang dipersonalisasi.',
        ),
        Clause(
          title: '2. Penggunaan Data',
          description:
              'Data Anda digunakan untuk memproses transaksi, mengelola akun, dan memberikan dukungan teknis. Kami tidak akan menjual atau menyewakan informasi pribadi Anda kepada pihak ketiga untuk tujuan pemasaran tanpa persetujuan eksplisit Anda.',
        ),
        Clause(
          title: '3. Keamanan Informasi',
          description:
              'Kami menerapkan standar keamanan industri untuk melindungi data pribadi Anda dari akses tidak sah, perubahan, atau pengungkapan. Namun, harap diingat bahwa tidak ada metode transmisi data melalui internet yang 100% aman.',
        ),
      ],
    ),
  };

  TermsAndConditions getTerms(TermsType type) {
    return _termsData[type]!;
  }

  void toggleAgree(TermsType type) {
    _termsData[type]!.isAgree = !_termsData[type]!.isAgree;
    notifyListeners();
  }

  bool isAgreed(TermsType type) {
    return _termsData[type]!.isAgree;
  }
}
