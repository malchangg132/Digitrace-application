class AkunUser {
  final int idUser;
  final String namaUser;
  final String emailUser;
  final String? statusUser;

  AkunUser({
    required this.idUser,
    required this.namaUser,
    required this.emailUser,
    this.statusUser,
  });

  // ubah data dari supabase (Map) jadi object AkunUser
  // password sengaja tidak dibawa ke aplikasi
  factory AkunUser.fromJson(Map<String, dynamic> json) {
    return AkunUser(
      idUser: json['id_user'] as int,
      namaUser: json['nama_user'] as String? ?? '',
      emailUser: json['email_user'] as String? ?? '',
      statusUser: json['status_user'] as String?,
    );
  }
}