import 'package:flutter/material.dart';

class RiwayatData {
  // pendidikan
  final String pendidikanTerakhir;
  final String namaUniversitas;
  final String programStudi;
  final String tahunMasuk;
  final String statusPendidikan;
  // pekerjaan
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
                    const SizedBox(height: 46),

                    // judul
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF244B73),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        'Perjalanan data alumni',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF9AA8BD),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // riwayat pdndidikan
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

                    // riwayat pkrjaan
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
          ],
        ),
      ),
    );
  }
}

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
            color: Color(0xFFD3DFF5),
          ),
          child: Icon(icon, size: 24, color: const Color(0xFF244B73)),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF244B73),
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
        color: const Color(0xFFDDE7F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A93A3), width: 1),
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
          Icon(icon, size: 22, color: const Color(0xFF244B73)),
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
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF244B73),
                      ),
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
                          color: Color(0xFF244B73),
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