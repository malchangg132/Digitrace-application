import 'package:flutter/material.dart';
import 'bottombar.dart';
import 'detail_alumni.dart';

// ====== WARNA ======
const Color kBlueDark = Color(0xFF264D7A);
const Color kBlueSoft = Color(0xFFE6EDFB);
const Color kGreyText = Color(0xFF8A8F98);

class Alumni {
  final String nama;
  final String angkatan;
  final String jurusan;
  final String status; 
  final String tempatTglLahir;
  final String tglLulus;
  final String kontak;
  final String email;
  final String alamat;
  final String namaInstansi;
  final String posisi;
  final String mulaiBekerja;

  const Alumni({
    required this.nama,
    required this.angkatan,
    required this.jurusan,
    required this.status,
    this.tempatTglLahir = 'Malang, 26 januari 2009',
    this.tglLulus = '30 Juni 2019',
    this.kontak = '1234567810',
    this.email = 'Irfanblarblarr@gmail.com',
    this.alamat = 'Jl Sumpil 3A,no 6',
    this.namaInstansi = 'PT.Indonesia Online',
    this.posisi = 'Digital Marketing',
    this.mulaiBekerja = '1 Agustus 2022',
  });
}

/// Warna badge status (dipakai juga di halaman detail)
class StatusStyle {
  final Color bg;
  final Color fg;
  const StatusStyle(this.bg, this.fg);

  static StatusStyle of(String status) {
    switch (status) {
      case 'Bekerja':
        return const StatusStyle(Color(0xFFD7E3FA), Color(0xFF3B5B8C));
      case 'Kuliah':
        return const StatusStyle(Color(0xFFFFF7D9), Color(0xFF7A6A2E));
      case 'Berwirausaha':
        return const StatusStyle(Color(0xFFE3F4DE), Color(0xFF3F7A3A));
      default:
        return const StatusStyle(Color(0xFFA9B4C8), Color(0xFF3A4660));
    }
  }
}

class DataAlumniScreen extends StatefulWidget {
  const DataAlumniScreen({super.key});

  @override
  State<DataAlumniScreen> createState() => _DataAlumniScreenState();
}

class _DataAlumniScreenState extends State<DataAlumniScreen> {
  final TextEditingController _searchC = TextEditingController();
  final List<String> _filters = ['Semua', 'Bekerja', 'Kuliah', 'Wirausaha', 'Lainnya'];
  String _selectedFilter = 'Semua';
  String _query = '';

  final List<Alumni> _alumni = const [
    Alumni(nama: 'Muhammad Irfan', angkatan: '2019', jurusan: 'RPL', status: 'Bekerja'),
    Alumni(nama: 'Suendah', angkatan: '2019', jurusan: 'RPL', status: 'Kuliah'),
    Alumni(nama: 'Nadya Ulya', angkatan: '2019', jurusan: 'RPL', status: 'Bekerja'),
    Alumni(nama: 'Adhon Panca', angkatan: '2019', jurusan: 'RPL', status: 'Berwirausaha'),
    Alumni(nama: 'Adzamar Mahdum', angkatan: '2019', jurusan: 'RPL', status: 'Lainnya'),
    Alumni(nama: 'Alvira Octiana', angkatan: '2019', jurusan: 'RPL', status: 'Berwirausaha'),
    Alumni(nama: 'Alya Nasmi', angkatan: '2019', jurusan: 'RPL', status: 'Kuliah'),
    Alumni(nama: 'Balqis Demes', angkatan: '2019', jurusan: 'RPL', status: 'Kuliah'),
  ];

  List<Alumni> get _filtered {
    return _alumni.where((a) {
      final matchFilter = _selectedFilter == 'Semua' ||
          (_selectedFilter == 'Wirausaha'
              ? a.status == 'Berwirausaha'
              : a.status == _selectedFilter);
      final q = _query.toLowerCase();
      final matchQuery = q.isEmpty ||
          a.nama.toLowerCase().contains(q) ||
          a.jurusan.toLowerCase().contains(q) ||
          a.angkatan.contains(q);
      return matchFilter && matchQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 24),
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: kBlueDark, size: 22),
                  ),
                  const SizedBox(width: 18),
                  const Text(
                    'Data Alumni',
                    style: TextStyle(
                      color: kBlueDark,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ===== SEARCH + FILTER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: kBlueDark, width: 1),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Icon(Icons.search, size: 16, color: kBlueDark),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchC,
                              onChanged: (v) => setState(() => _query = v),
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                hintText: 'Cari nama, NIS, atau jurusan',
                                hintStyle: TextStyle(
                                    fontSize: 12, color: kGreyText),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  const Icon(Icons.filter_alt_outlined,
                      color: kBlueDark, size: 22),
                  const SizedBox(width: 6),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== CHIP FILTER =====
            SizedBox(
              height: 22,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final selected = f == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? kBlueDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kBlueDark, width: 1),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : kBlueDark,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),

            // ===== LIST =====
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: kBlueSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: data.isEmpty
                    ? const Center(
                        child: Text('Data tidak ditemukan',
                            style: TextStyle(color: kGreyText)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) => _AlumniTile(
                          alumni: data[i],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailAlumniScreen(alumni: data[i]),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlumniTile extends StatelessWidget {
  final Alumni alumni;
  final VoidCallback onTap;
  const _AlumniTile({required this.alumni, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(alumni.status);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB9C7E2),
                ),
                child: const Icon(Icons.face, size: 22, color: Color(0xFF1B1B2F)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alumni.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${alumni.angkatan} - ${alumni.jurusan}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: kGreyText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: style.bg,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  alumni.status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: style.fg,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded,
                  color: kBlueDark, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
