import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tracer_study.dart';

class TracerService {
  final _db = Supabase.instance.client;

  // ambil data tracer study milik satu alumni (null kalau belum pernah isi)
  Future<TracerStudy?> ambil(int idUser) async {
    final data = await _db
        .from('tracer_study')
        .select()
        .eq('id_user', idUser)
        .maybeSingle();

    return data == null ? null : TracerStudy.fromJson(data);
  }

  // simpan tracer study: kalau belum ada dibuat baru, kalau sudah ada diperbarui
  Future<void> simpan(TracerStudy tracer) async {
    final ada = await _db
        .from('tracer_study')
        .select('id_user')
        .eq('id_user', tracer.idUser)
        .maybeSingle();

    if (ada == null) {
      await _db.from('tracer_study').insert(tracer.toJson());
    } else {
      final data = tracer.toJson()..remove('id_user');
      await _db
          .from('tracer_study')
          .update(data)
          .eq('id_user', tracer.idUser);
    }
  }
}