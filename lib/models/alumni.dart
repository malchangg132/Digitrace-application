class Alumni {
  final int idUser;
  final String? namaUser;
  final String? statusUser;
  final int? tahunLulus;
  final String? jurusan;
  final String? tempatTanggalLahir;
  final String? noHp;
  final String? alamatLengkap;

  Alumni({
    required this.idUser,
    this.namaUser,
    this.statusUser,
    this.tahunLulus,
    this.jurusan,
    this.tempatTanggalLahir,
    this.noHp,
    this.alamatLengkap,
  });

  // ubah data dari supabase (Map) jadi object Alumni
  factory Alumni.fromJson(Map<String, dynamic> json) {
    // nama & status diambil dari tabel user (hasil join)
    final user = json['user'];
    return Alumni(
      idUser: json['id_user'] as int,
      namaUser: user is Map ? user['nama_user'] as String? : null,
      statusUser: user is Map ? user['status_user'] as String? : null,
      tahunLulus: int.tryParse(json['tahun_lulus'].toString()),
      jurusan: json['jurusan'] as String?,
      tempatTanggalLahir: json['tempattanggal_lahir'] as String?,
      noHp: json['no_hp']?.toString(),
      alamatLengkap: json['alamat_lengkap'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'tahun_lulus': tahunLulus,
      'jurusan': jurusan,
      'tempattanggal_lahir': tempatTanggalLahir,
      'no_hp': noHp,
      'alamat_lengkap': alamatLengkap,
    };
  }
}