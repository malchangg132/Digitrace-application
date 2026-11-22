import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hasil_login.dart';

class LoginService {
  final _db = Supabase.instance.client;

  // kirim email dan password ke fungsi login_akun di supabase
  // hasilnya null kalau email atau password salah
  Future<HasilLogin?> masuk(String email, String password) async {
    final data = await _db.rpc('login_akun', params: {
      'p_email': email.trim(),
      'p_password': password,
    });

    if (data == null) return null;
    return HasilLogin.fromJson(Map<String, dynamic>.from(data as Map));
  }
}