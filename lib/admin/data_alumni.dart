import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'detail_alumni.dart';

class DataAlumni extends StatefulWidget {
  final VoidCallback onBack;

  const DataAlumni({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  _DataAlumniState createState() => _DataAlumniState();
}

class _DataAlumniState extends State<DataAlumni> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> dataAlumni = [];

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'Semua';

  bool _isLoading = true;

  // Pagination
  int _halamanAktif = 1;
  final int _jumlahPerHalaman = 10;

  // Mengambil seluruh akun user dan biodata alumni
  Future<List<Map<String, dynamic>>> _ambilDataAlumni() async {
    final data = await supabase.from('user').select('''
      id_user,
      nama_user,
      status_user,
      alumni (
        id,
        tahun_lulus,
        jurusan,
        tempattanggal_lahir,
        no_hp,
        alamat_lengkap,
        status_aktif,
        pendidikan_terakhir,
        nama_universitas,
        program_study,
        tahun_masuk,
        nama_perusahaan,
        posisi_jabatan,
        bidang_pekerjaan,
        lokasi_pekerjaan
      )
    ''');

    return data.map((item) {
      final rawAlumni = item['alumni'];

      Map<String, dynamic> biodata = {};

      if (rawAlumni is List && rawAlumni.isNotEmpty) {
        biodata = Map<String, dynamic>.from(rawAlumni.first);
      } else if (rawAlumni is Map) {
        biodata = Map<String, dynamic>.from(rawAlumni);
      }

      return {
        ...biodata,
        'id_user': item['id_user'],
        'user': {
          'nama_user': item['nama_user'],
          'status_user': item['status_user'],
        },
      };
    }).toList();
  }

  // Mengambil data dari Supabase
  Future<void> _cekData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final data = await _ambilDataAlumni();

      if (!mounted) return;

      setState(() {
        dataAlumni = data;
        _isLoading = false;
      });

      debugPrint('Jumlah akun alumni: ${data.length}');

      for (final alumni in data) {
        debugPrint(
          'Nama: ${alumni['user']?['nama_user']} '
          '| Status: ${alumni['status_aktif']}',
        );
      }
    } catch (error) {
      debugPrint('Error Supabase: $error');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filter berdasarkan status tracer study
  List<Map<String, dynamic>> get _dataAlumniFilter {
    if (_selectedFilter == 'Semua') {
      return dataAlumni;
    }

    if (_selectedFilter == 'Lainnya') {
      return dataAlumni.where((alumni) {
        final status = alumni['status_aktif']?.toString();

        return status == null ||
            status.isEmpty ||
            ![
              'Bekerja',
              'Kuliah',
              'Wirausaha',
            ].contains(status);
      }).toList();
    }

    return dataAlumni.where((alumni) {
      return alumni['status_aktif'] == _selectedFilter;
    }).toList();
  }

  // Pencarian nama alumni
  List<Map<String, dynamic>> get _dataAlumniCari {
    return _dataAlumniFilter.where((alumni) {
      final nama = alumni['user']?['nama_user']
              ?.toString()
              .toLowerCase() ??
          '';

      return nama.contains(
        _searchController.text.toLowerCase(),
      );
    }).toList();
  }

  // Menghitung jumlah halaman
  int get _totalHalaman {
    return (_dataAlumniCari.length / _jumlahPerHalaman).ceil();
  }

  // Data yang ditampilkan pada halaman aktif
  List<Map<String, dynamic>> get _dataAlumniPerHalaman {
    int awal = (_halamanAktif - 1) * _jumlahPerHalaman;

    if (awal >= _dataAlumniCari.length) {
      return [];
    }

    int akhir = awal + _jumlahPerHalaman;

    if (akhir > _dataAlumniCari.length) {
      akhir = _dataAlumniCari.length;
    }

    return _dataAlumniCari.sublist(awal, akhir);
  }

  // Nomor halaman pagination
  List<int> get _nomorHalaman {
    if (_totalHalaman <= 3) {
      return List.generate(
        _totalHalaman,
        (index) => index + 1,
      );
    }

    if (_halamanAktif <= 2) {
      return [1, 2, 3];
    }

    if (_halamanAktif >= _totalHalaman - 1) {
      return [
        _totalHalaman - 2,
        _totalHalaman - 1,
        _totalHalaman,
      ];
    }

    return [
      _halamanAktif - 1,
      _halamanAktif,
      _halamanAktif + 1,
    ];
  }

  // Tombol filter
  Widget _filterItem(String title) {
    final isSelected = _selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = title;
          _halamanAktif = 1;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF28527A)
              : Colors.white,
          border: Border.all(
            color: const Color(0xFF28527A),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : const Color(0xFF28527A),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cekData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF28527A),
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'Data Alumni',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF28527A),
                  ),
                ),
              ],
            ),
          ),

          // Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _halamanAktif = 1;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama, NIS, atau jurusan',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            child: Row(
              children: [
                _filterItem('Semua'),
                const SizedBox(width: 8),
                _filterItem('Bekerja'),
                const SizedBox(width: 8),
                _filterItem('Kuliah'),
                const SizedBox(width: 8),
                _filterItem('Wirausaha'),
                const SizedBox(width: 8),
                _filterItem('Lainnya'),
              ],
            ),
          ),

          // Daftar alumni
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _dataAlumniCari.isEmpty
                    ? const Center(
                        child: Text(
                          'Data tidak ditemukan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        itemCount: _dataAlumniPerHalaman.length,
                        itemBuilder: (context, index) {
                          final alumni =
                              _dataAlumniPerHalaman[index];

                          final nama = alumni['user']
                                  ?['nama_user']
                                  ?.toString() ??
                              'Nama tidak tersedia';

                          // Mengambil status dari tabel alumni
                          final status = alumni['status_aktif']
                                      ?.toString()
                                      .trim()
                                      .isNotEmpty ==
                                  true
                              ? alumni['status_aktif'].toString()
                              : 'Belum mengisi';

                          final tahunLulus =
                              alumni['tahun_lulus']?.toString() ??
                                  '-';

                          final jurusan =
                              alumni['jurusan']?.toString() ?? '-';

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailAlumni(
                                      alumni: alumni,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFE3E3E3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Color(0xFFB4D1FF),
                                      child: Icon(
                                        Icons.face_3,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nama,
                                            style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Angkatan $tahunLulus',
                                          ),
                                          const SizedBox(height: 3),
                                          Text(jurusan),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color(0xFFE8F0FA),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status,
                                        style: const TextStyle(
                                          color: Color(0xFF28527A),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF28527A),
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // Pagination
          if (!_isLoading && _totalHalaman > 0)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _halamanAktif > 1
                        ? () {
                            setState(() {
                              _halamanAktif--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),

                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_halamanAktif > 2) ...[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _halamanAktif = 1;
                                });
                              },
                              child: const Text('1'),
                            ),
                            const Text('...'),
                          ],

                          for (final nomor in _nomorHalaman)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _halamanAktif = nomor;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _halamanAktif == nomor
                                      ? const Color(0xFF849DBB)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$nomor',
                                  style: TextStyle(
                                    color: _halamanAktif == nomor
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),

                          if (_nomorHalaman.isNotEmpty &&
                              _nomorHalaman.last != _totalHalaman) ...[
                            const Text('...'),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _halamanAktif = _totalHalaman;
                                });
                              },
                              child: Text('$_totalHalaman'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: _halamanAktif < _totalHalaman
                        ? () {
                            setState(() {
                              _halamanAktif++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}