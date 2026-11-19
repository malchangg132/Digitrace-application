import 'package:flutter/material.dart';

// WARNA
const Color _kBlueDark = Color(0xFF264D7A);
const Color _kMuted = Color(0xFF9AA8BD);
const Color _kCircle = Color(0xFFD3DFF5);
const Color _kCard = Color(0xFFDDE7F9);
const Color _kCardBorder = Color(0xFF8A93A3);


class RiwayatData {
  // Pendidikan
  final String pendidikanTerakhir;
  final String namaUniversitas;
  final String programStudi;
  final String tahunMasuk;
  final String statusPendidikan;
  // Pekerjaan
  final String statusKerja;
  final String namaPerusahaan;
  final String posisi;
  final String bidang;
  final String lokasi;

  const RiwayatData({
    required this.pendidikanTerakhir,
    required this.namaUniversitas,
    required this.programStudi,
    required this.tahunMasuk,
    required this.statusPendidikan,
    required this.statusKerja,
    required this.namaPerusahaan,
    required this.posisi,
    required this.bidang,
    required this.lokasi,
  });
}

class RiwayatScreen extends StatelessWidget {
  final RiwayatData data;
  const RiwayatScreen({super.key, required this.data});

  void _onNavTap(BuildContext context, int i) {
    switch (i) {
      case 0: // Beranda -> kembali ke Dashboard
        Navigator.maybePop(context);
        break;
      case 1: // Tracer
      case 3: // Profil
        // kembali ke Dashboard, lalu Dashboard membuka tab tersebut
        Navigator.pop(context, i);
        break;
      default:
        break; // sedang di Riwayat
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    // ===== PANAH KEMBALI =====
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.maybePop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.arrow_back,
                              size: 20, color: _kBlueDark),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ===== JUDUL =====
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _kBlueDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Perjalanan data alumni',
                        style: TextStyle(fontSize: 10.5, color: _kMuted),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ===== RIWAYAT PENDIDIKAN =====
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _SectionTitle(
                        icon: Icons.school,
                        text: 'Riwayat Pendidikan',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _InfoCard(
                        icon: Icons.menu_book_outlined,
                        rows: [
                          ('Pendidikan terakhir', data.pendidikanTerakhir),
                          ('Nama Universitas', data.namaUniversitas),
                          ('Program Studi', data.programStudi),
                          ('Tahun Masuk', data.tahunMasuk),
                          ('Status Pendidikan', data.statusPendidikan),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ===== RIWAYAT PEKERJAAN =====
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _SectionTitle(
                        icon: Icons.work_outline,
                        text: 'Riwayat Pekerjaan',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _InfoCard(
                        icon: Icons.work_outline,
                        rows: [
                          ('Status saat ini', data.statusKerja),
                          ('Nama Perusahaan', data.namaPerusahaan),
                          ('Posisi/Jabatan', data.posisi),
                          ('Bidang Pekerjaan', data.bidang),
                          ('Lokasi Perusahaan', data.lokasi),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomNav(
              selectedIndex: 2,
              onTap: (i) => _onNavTap(context, i),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET PEMBANTU

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SectionTitle({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: _kCircle,
          ),
          child: Icon(icon, size: 24, color: _kBlueDark),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _kBlueDark,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final List<(String, String)> rows;

  const _InfoCard({required this.icon, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kCardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: _kBlueDark),
          const SizedBox(height: 4),
          for (final r in rows)
            SizedBox(
              height: 23,
              child: Row(
                children: [
                  Expanded(
                    flex: 54,
                    child: Text(
                      r.$1,
                      style: const TextStyle(fontSize: 10, color: _kBlueDark),
                    ),
                  ),
                  Expanded(
                    flex: 46,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        r.$2,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _kBlueDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, 'Beranda'),
      (Icons.description_outlined, 'Tracer'),
      (Icons.history, 'Riwayat'),
      (Icons.person_outline, 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6F4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border.all(color: const Color(0xFFD5DBD8)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == selectedIndex;
              final color = selected
                  ? const Color(0xFF1B2B45)
                  : const Color(0xFF4F6F95);
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i].$1, size: 34, color: color),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}