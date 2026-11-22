class HasilLogin {
  final String role; // 'admin', 'guru', atau 'user'
  final int id;
  final String nama;

  HasilLogin({
    required this.role,
    required this.id,
    required this.nama,
  });

  // ubah balasan dari fungsi login jadi object HasilLogin
  factory HasilLogin.fromJson(Map<String, dynamic> json) {
    return HasilLogin(
      role: json['role'] as String,
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String? ?? '',
    );
  }
}