
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tracer_study.dart';

class TracerService {
  final _db = Supabase.instance.client;

  // Mengambil tracer study terbaru
  Future<TracerStudy?> ambil(int idUser) async {
    final data = await _db
        .from('tracer_study')
        .select()
        .eq('id_user', idUser)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return data == null ? null : TracerStudy.fromJson(data);
  }

  // Mengambil semua riwayat tracer study
  Future<List<TracerStudy>> ambilSemua(int idUser) async {
    final data = await _db
        .from('tracer_study')
        .select()
        .eq('id_user', idUser)
        .order('created_at', ascending: false);

    return data.map((item) => TracerStudy.fromJson(item)).toList();
  }

  // Menyimpan tracer study dan biodata alumni
  Future<void> simpan(
    TracerStudy tracer, {
    required Map<String, dynamic> biodata,
  }) async {
    // 1. Simpan riwayat tracer study baru
    await _db.from('tracer_study').insert(tracer.toJson());

    // 2. Gabungkan biodata dan informasi tracer terbaru
    final dataAlumni = {
      ...biodata,
      'status_aktif': tracer.statusAktif,
      'pendidikan_terakhir': tracer.pendidikanTerakhir,
      'nama_universitas': tracer.namaUniversitas,
      'program_study': tracer.programStudy,
      'tahun_masuk': tracer.tahunMasuk,
      'nama_perusahaan': tracer.namaPerusahaan,
      'posisi_jabatan': tracer.posisiJabatan,
      'bidang_pekerjaan': tracer.bidangPekerjaan,
      'lokasi_pekerjaan': tracer.lokasiPekerjaan,
    };

    // 3. Periksa apakah profil alumni sudah tersedia
    final alumni = await _db
        .from('alumni')
        .select('id')
        .eq('id_user', tracer.idUser)
        .maybeSingle();

    if (alumni == null) {
      // Jika belum ada, buat profil alumni
      await _db.from('alumni').insert({
        'id_user': tracer.idUser,
        ...dataAlumni,
      });
    } else {
      // Jika sudah ada, perbarui profil alumni
      await _db
          .from('alumni')
          .update(dataAlumni)
          .eq('id_user', tracer.idUser);
    }
  }
}
