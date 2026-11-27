import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataAlumni extends StatefulWidget {
  //perintah untuk kembali ke dashboard admin 
  final VoidCallback onBack;
  const DataAlumni({Key? key, 
  required this.onBack,}) : super(key: key);

  @override
  _DataAlumniState createState() => _DataAlumniState();

  
}

class _DataAlumniState extends State<DataAlumni> {
  Future<List<Map<String, dynamic>>> _ambilDataAlumni () async {
    final data = await supabase
    .from('alumni')
    .select('''id, id_user, tahun_lulus, jurusan, user (nama_user, status_user)''');

  return data;
  }

  // Inisialisasi 
  final supabase = Supabase.instance.client;

  // Mengambil data alumni
 List<Map<String, dynamic>> dataAlumni = [];

  // Memeriksa data alumni dan data user
  Future<void> _cekData() async {
    try {
      final data = await _ambilDataAlumni();

      if(mounted) {
        setState(() {
          dataAlumni = data;
        });
      }

      debugPrint('Data Alumni: $data');
    } catch (error) {
      debugPrint('Error Supabase: $error');
    }
  }

  String _selectedFilter = 'Semua';
      final TextEditingController _searchController = TextEditingController();

      //pagination
      int _halamanAktif = 1;
      int _jumlahPerHalaman = 10;


  List<Map<String,dynamic>> get _dataAlumniFilter {
    if(_selectedFilter == 'Semua') {
      return dataAlumni;
    }
    return dataAlumni.where((alumni) {
      return alumni['user']?['status_user'] ==_selectedFilter;
    }).toList();
  }

  //fungsi pencarian
  List<Map<String,dynamic>> get _dataAlumniCari {
    return _dataAlumniFilter.where((alumni) {
      final nama = alumni['user']?['nama_user']?.toString().toLowerCase() ?? '';

      return nama.contains(_searchController.text.toLowerCase());
    }).toList();
  }

  //getter hitung jumlah halaman
  int get _totalHalaman {
    return (_dataAlumniCari.length / _jumlahPerHalaman).ceil();
  }

  //getter data perhalaman
  List<Map<String, dynamic>> get _dataAlumniPerHalaman {
    int awal = (_halamanAktif - 1) * _jumlahPerHalaman;
    int akhir = awal + _jumlahPerHalaman;
    if (akhir > _dataAlumniCari.length) {
      akhir = _dataAlumniCari.length;
    }
    return _dataAlumniCari.sublist(awal,akhir);
  }

  //getter menentukan tiga nomor halaman
  List<int> get _nomorHalaman {
    if (_totalHalaman <= 3) {
      return List.generate(_totalHalaman, (index) => index + 1);
    }
    if (_halamanAktif <= 2) {
      return [1,2,3];
    }
    if (_halamanAktif >= _totalHalaman -1) {
      return [
        _totalHalaman - 2,
        _totalHalaman -1,
        _totalHalaman,
      ];
    }

    return [
      _halamanAktif -1,
      _halamanAktif,
      _halamanAktif +1,
    ];
  }

  // Fungsi filter item
  Widget _filterItem(String title, bool isSelected) {
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
          color: _selectedFilter == title
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
            color: _selectedFilter == title
                ? Colors.white
                : const Color(0xFF28527A),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    debugPrint('Halaman Data Alumni dibuka');

    _cekData();
  }

  @override
  //bagian header
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack, //tombol panah mengubah _selectedIndex jadi 0,jadi kembali ke Dashboard Admin.
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 10),
                const Icon(
                  Icons.filter_list,
                  size: 28,
                  color: Color(0xFF28527A),
                ),
              ],
            ),
          ),

          // Filter data alumni
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 15,
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                _filterItem('Semua', true),

                const SizedBox(width: 8),
                _filterItem('Bekerja', false),

                const SizedBox(width: 8),
                _filterItem('Kuliah', false),

                const SizedBox(width: 8),
                _filterItem('Wirausaha', false),

                const SizedBox(width: 8),
                _filterItem('Lainnya', false),
              ],
            ),
          ),
          Expanded(
            child: _dataAlumniCari.isEmpty
                ? const Center(
                  child: Text('Data tidak ditemukan', style: TextStyle(fontSize: 14, color: Colors.grey)),
                )
              : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _dataAlumniPerHalaman.length,
              itemBuilder: (context, index) {
                final alumni = _dataAlumniPerHalaman[index];  //hubungkan hasil pencarian ke daftar kartu

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE3E3E3),),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color.fromARGB(255, 180, 209, 255),
                          child: const Icon(Icons.face_3, color: Colors.black,),
                        ),
                        const SizedBox(width: 12,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alumni['user']?['nama_user']?? 'Nama tidak tersedia',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 5,),
                            Text('Angkatan ${alumni['tahun_lulus']?? '-'}'),
                            const SizedBox(height: 3),
                            Text(alumni['jurusan'] ?? '-'),
                          ],
                        ),
                        const Spacer(),

                        Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(alumni?['user']?['status_user']?? '-',
                          style: TextStyle(color: Color(0xFF28527A), fontSize: 12),
                        ),
                       ),
                         const SizedBox(width: 30),
                           const Icon(Icons.arrow_forward, color: Color(0xFF28527A), size: 24,),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          //Pagination
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12,),
            child: Row(
              children: [
                IconButton(
                  onPressed: _halamanAktif > 1 ? () {
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            child: Text('$nomor',
                            style: TextStyle(
                              color: _halamanAktif == nomor
                                ? Colors.white
                                : Colors.black,
                            ),
                           ),
                          ),
                        ),

                        //menampilkan halaman terakhir jika belum keliatan
                        if (_totalHalaman > 0 &&
                        _nomorHalaman.isNotEmpty &&
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
                    onPressed: _halamanAktif < _totalHalaman ? () {
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