import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/adminservice.dart'; 
import '../services/sesi.dart'; 
import '../halaman/loginscreen.dart'; 
import 'informasiakun.dart';
import 'tentangaplikasi.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
  //data admin yang tampil, kosong tampil "-" 
  String _nama = '-';
  String _email = '-';

  @override
  void initState() {
    super.initState();
    _muatData(); 
  }

  // ambil data admin dari supabase 
  Future<void> _muatData() async {
    try {
      final akun = await AdminService.ambilAkun(Sesi.akun!.id);
      if (akun == null || !mounted) return;
      setState(() {
        _nama = akun.nama.isEmpty ? '-' : akun.nama;
        _email = akun.email.isEmpty ? '-' : akun.email;
      });
    } catch (e) {
      //kalau gagal, tetap tampil "-"
    }
  }

  // tanya dulu mau logout atau tidak 
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
              style: TextStyle(color: Color(0xFFA50E0E)),
            ),
          ),
        ],
      ),
    );

    if (ya == true && mounted) {
      Sesi.keluar(); //hapus data login
      //buka halaman login, semua halaman sebelumnya dihapus
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Loginscreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 40, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJudul(),
              const SizedBox(height: 20),
              _buildKartuProfil(),
              const SizedBox(height: 24),
              _buildKartuMenu(context),
              const SizedBox(height: 20),
              _buildLogout(context),
            ],
          ),
        ),
      ),
    );
  }

  // judul
  Widget _buildJudul() {
    return const Text(
      'Profil Admin',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  // card profil
  Widget _buildKartuProfil() {
    return _KartuPutih(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Row(
              children: [
                //foto profil (garis)
                const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: Colors.black,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        _nama, 
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email,
                              size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _email, 
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //badge admin pojok kanan atas
          Positioned(
            top: 8,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Admin',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF2E5E2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // menu
  Widget _buildKartuMenu(BuildContext context) {
    return _KartuPutih(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          children: [
            _MenuItem(
              icon: Icons.person,
              judul: 'Informasi Akun',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InformasiAkunAdmin(
                      nama: _nama, 
                      email: _email, 
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            _MenuItem(
              icon: Icons.info,
              judul: 'Tentang Aplikasi',
              subjudul: 'Informasi Aplikasi',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TentangAplikasiAdmin()),
                );
              },
            ),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
          ],
        ),
      ),
    );
  }

  // logout
  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            onPressed: _logout, 
            icon: const Icon(Icons.logout, size: 18, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA50E0E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// card putih
class _KartuPutih extends StatelessWidget {
  final Widget child;

  const _KartuPutih({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// menu
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String? subjudul;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.judul,
    this.subjudul,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            //ikon bulat
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFC3D0E6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (subjudul != null)
                    Text(
                      subjudul!,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}