import 'package:flutter/material.dart';
import 'package:digitrace/halaman/loginscreen.dart';
import 'package:digitrace/services/sesi.dart';
import 'package:digitrace/services/user_service.dart'; 
import 'package:digitrace/services/alumni_service.dart'; 
import 'editprofil.dart';
import 'tentangaplikasi.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // nanti dgnti sm supabase
  ProfilData _data = const ProfilData(
    nama: '-',
    ttl: '-',
    jurusan: '-',
    tahunLulus: '-',
    email: '-',
    noHp: '-',
  );

  //ambil data waktu halaman pertama dibuka
  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  //kalau data kosong tampilkan "-"
  String _isi(String? teks) {
    if (teks == null || teks.isEmpty) return '-';
    return teks;
  }

  //ambil data akun/tabel user dan data alumni dari supabase
  Future<void> _ambilData() async {
    final sesi = Sesi.akun;
    if (sesi == null) return;

    try {
      final akun = await UserService().ambilAkun(sesi.id);
      final alumni = await AlumniService().ambilSatu(sesi.id);

      if (!mounted) return;
      setState(() {
        _data = ProfilData(
          nama: _isi(akun?.namaUser),
          ttl: _isi(alumni?.tempatTanggalLahir),
          jurusan: _isi(alumni?.jurusan),
          tahunLulus: _isi(alumni?.tahunLulus?.toString()),
          email: _isi(akun?.emailUser),
          noHp: _isi(alumni?.noHp),
        );
      });
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal mengambil data profil');
    }
  }

  List<(String, String)> get _rows => [
        ('Nama Lengkap', _data.nama),
        ('Tempat, Tanggal lahir', _data.ttl),
        ('Jurusan', _data.jurusan),
        ('Tahun Lulus', _data.tahunLulus),
        ('Email', _data.email),
        ('Nomor HP', _data.noHp),
      ];

  void _showSnack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _openEdit() async {
    final result = await Navigator.push<ProfilData>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilScreen(data: _data)),
    );
    if (result == null || !mounted) return;
    setState(() => _data = result);
    _showSnack('Profil berhasil diperbarui');
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Digitrace',
      applicationVersion: '1.0.0',
      children: const [
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text('Aplikasi tracer study untuk memantau perkembangan alumni.'),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: Color(0xFF7F0A0A)),
            ),
          ),
        ],
      ),
    );

    if (ya == true && mounted) {
      Sesi.keluar(); //hapus data login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Loginscreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 46),

                    // judull
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF244B73),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),

                    // card data pribadi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _Card(
                        padding: const EdgeInsets.fromLTRB(18, 17, 18, 8),
                        child: Column(
                          children: [
                            const _CardHeader(
                              icon: Icons.person_outline,
                              text: 'Data Pribadi',
                            ),
                            const SizedBox(height: 18),
                            for (int i = 0; i < rows.length; i++) ...[
                              if (i > 0)
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFDCE1EA),
                                ),
                              _DataRow(
                                label: rows[i].$1,
                                value: rows[i].$2,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // card pengaturan akun
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _Card(
                        padding: const EdgeInsets.fromLTRB(18, 17, 18, 30),
                        child: Column(
                          children: [
                            const _CardHeader(
                              icon: Icons.settings_outlined,
                              text: 'Pengaturan Akun',
                            ),
                            const SizedBox(height: 14),
                            _MenuRow(
                              icon: Icons.edit_outlined,
                              title: 'Ubah Profil',
                              subtitle: 'Email, Password akun, Nomor Hp',
                              onTap: _openEdit,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFDCE1EA),
                            ),
                            _MenuRow(
                              icon: Icons.info_outline,
                              title: 'Tentang aplikasi',
                              onTap: _showAbout,
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFDCE1EA),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // logout
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: ElevatedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, size: 16),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7F0A0A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _Card({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CardHeader({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF244B73)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF244B73),
          ),
        ),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;

  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            flex: 46,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF244B73),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 54,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF244B73),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: subtitle != null ? 7 : 9),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF244B73)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF244B73),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 8.5,
                        color: Color(0xFF7D8BA3),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 22,
              color: Color(0xFF244B73),
            ),
          ],
        ),
      ),
    );
  }
}