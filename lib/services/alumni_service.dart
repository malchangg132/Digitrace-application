import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/alumni.dart';

class AlumniService {
  final _db = Supabase.instance.client;

  // ambil semua alumni beserta nama & status dari tabel user
  Future<List<Alumni>> ambilSemua() async {
    final data = await _db
        .from('alumni')
        .select('*, user(nama_user, status_user)')
        .order('tahun_lulus', ascending: false);

    return data.map((e) => Alumni.fromJson(e)).toList();
  }

  // ambil satu alumni berdasarkan id_user
  Future<Alumni?> ambilSatu(int idUser) async {
    final data = await _db
        .from('alumni')
        .select('*, user(nama_user, status_user)')
        .eq('id_user', idUser)
        .maybeSingle();

    return data == null ? null : Alumni.fromJson(data);
  }

  // simpan perubahan profil alumni (dipakai di halaman edit profil)
  Future<void> perbarui(Alumni alumni) async {
    final data = alumni.toJson()..remove('id_user');
    await _db.from('alumni').update(data).eq('id_user', alumni.idUser);
  }
}