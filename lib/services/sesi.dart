import '../models/hasil_login.dart';

// menyimpan siapa yang sedang login selama aplikasi terbuka
class Sesi {
  static HasilLogin? akun;

  static bool get sudahLogin => akun != null;

  static void keluar() {
    akun = null;
  }
}