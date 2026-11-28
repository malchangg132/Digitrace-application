import 'package:flutter/material.dart';
import 'package:digitrace/services/sesi.dart';
import 'package:digitrace/services/tracer_service.dart'; 
import 'package:digitrace/models/tracer_study.dart';

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

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  //data dr supabase
  List<TracerStudy> _daftarRiwayat = [];

  // ambil data waktu halaman dibuka
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

  //ambil data tracer study dari supabase
  Future<void> _ambilData() async {
    final sesi = Sesi.akun;
    if (sesi == null) return;

    try {
      final daftarTracer = await TracerService().ambilSemua(sesi.id);
      if (!mounted) return;
      if (daftarTracer.isEmpty) return;

      final tracer = daftarTracer.first;

      setState(() {
        _daftarRiwayat = daftarTracer;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data riwayat')),
      );
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
                    ..._daftarRiwayat.map((tracer) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _InfoCard(
                        icon: Icons.menu_book_outlined,
                        rows: [
                          ('Pendidikan terakhir', _isi(tracer.pendidikanTerakhir)),
                          ('Nama Universitas', _isi(tracer.namaUniversitas)),
                          ('Program Studi', _isi(tracer.programStudy)),
                          ('Tahun Masuk', _isi(tracer.tahunMasuk?.toString())),
                          ('Status Pendidikan', '-'),
                        ],
                      ),
                      )
                      ],
                    );
                  }),
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

                    ..._daftarRiwayat.map((tracer) {
                    return Column(
                      children: [
                          const SizedBox(height: 16),
                        Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _InfoCard(
                          icon: Icons.work_outline,
                          rows: [
                            ('Status saat ini', _isi(tracer.statusAktif)),
                            ('Nama Perusahaan', _isi(tracer.namaPerusahaan)),
                            ('Posisi/Jabatan', _isi(tracer.posisiJabatan)),
                            ('Bidang Pekerjaan', _isi(tracer.bidangPekerjaan)),
                            ('Lokasi Perusahaan', _isi(tracer.lokasiPekerjaan)),
                          ],
                        ),
                        )
                      ],
                    );
                  }),
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