class TracerStudy {
  final int idUser;
  final String? statusAktif;
  final String? pendidikanTerakhir;
  final String? namaUniversitas;
  final String? programStudy;
  final int? tahunMasuk;
  final String? namaPerusahaan;
  final String? posisiJabatan;
  final String? bidangPekerjaan;
  final String? lokasiPekerjaan;

  TracerStudy({
    required this.idUser,
    this.statusAktif,
    this.pendidikanTerakhir,
    this.namaUniversitas,
    this.programStudy,
    this.tahunMasuk,
    this.namaPerusahaan,
    this.posisiJabatan,
    this.bidangPekerjaan,
    this.lokasiPekerjaan,
  });

  // ubah data dari supabase (Map) jadi object TracerStudy
  factory TracerStudy.fromJson(Map<String, dynamic> json) {
    return TracerStudy(
      idUser: json['id_user'] as int,
      statusAktif: json['status_aktif'] as String?,
      pendidikanTerakhir: json['pendidikan_terakhir'] as String?,
      namaUniversitas: json['nama_universitas'] as String?,
      programStudy: json['program_study'] as String?,
      tahunMasuk: int.tryParse(json['tahun_masuk'].toString()),
      namaPerusahaan: json['nama_perusahaan'] as String?,
      posisiJabatan: json['posisi_jabatan'] as String?,
      bidangPekerjaan: json['bidang_pekerjaan'] as String?,
      lokasiPekerjaan: json['lokasi_pekerjaan'] as String?,
    );
  }

  // ubah object TracerStudy jadi Map untuk dikirim ke supabase
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'status_aktif': statusAktif,
      'pendidikan_terakhir': pendidikanTerakhir,
      'nama_universitas': namaUniversitas,
      'program_study': programStudy,
      'tahun_masuk': tahunMasuk,
      'nama_perusahaan': namaPerusahaan,
      'posisi_jabatan': posisiJabatan,
      'bidang_pekerjaan': bidangPekerjaan,
      'lokasi_pekerjaan': lokasiPekerjaan,
    };
  }
}