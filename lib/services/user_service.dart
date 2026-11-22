import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/akun_user.dart';

class UserService {
  final _db = Supabase.instance.client;

  // ambil akun berdasarkan id_user (tanpa password)
  Future<AkunUser?> ambilAkun(int idUser) async {
    final data = await _db
        .from('user')
        .select('id_user, nama_user, email_user, status_user')
        .eq('id_user', idUser)
        .maybeSingle();

    return data == null ? null : AkunUser.fromJson(data);
  }

  // ubah nama di tabel user
  Future<void> ubahNama(int idUser, String nama) async {
    await _db.from('user').update({'nama_user': nama}).eq('id_user', idUser);
  }
}