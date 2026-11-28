// bentuk data tabel admin (tanpa password)
class AkunAdmin {
  final int id;
  final String nama;
  final String email;

  AkunAdmin({
    required this.id,
    required this.nama,
    required this.email,
  });

  // ubah baris dari tabel admin jadi object AkunAdmin
  factory AkunAdmin.fromJson(Map<String, dynamic> json) {
    return AkunAdmin(
      id: (json['id_admin'] as num).toInt(),
      nama: json['nama_admin'] as String? ?? '',
      email: json['email_admin'] as String? ?? '',
    );
  }
}