import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/akunadmin.dart';

// kode yang ambil data admin dari Supabase
class AdminService {
  static final _db = Supabase.instance.client;

  // ambil 1 admin berdasarkan id, password tidak ikut diambil
  static Future<AkunAdmin?> ambilAkun(int id) async {
    final data = await _db
        .from('admin')
        .select('id_admin, nama_admin, email_admin')
        .eq('id_admin', id)
        .maybeSingle();

    if (data == null) return null;
    return AkunAdmin.fromJson(data);
  }
}