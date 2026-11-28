import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../grafik/grafikperkembangan.dart';

class DashAdmin extends StatefulWidget {
  const DashAdmin({ Key? key }) : super(key: key);

  @override
  _DashAdminState createState() => _DashAdminState();
  }



class _DashAdminState extends State<DashAdmin> {
  final supabase = Supabase.instance.client;

  late Future<Map<String, int>> _statistikFuture;

  @override
  void initState() {
    super.initState();
    _statistikFuture = _ambilStatistik();
  }

  //mengambil jumlah alumni
  Future<Map<String, int>> _ambilStatistik() async {
    //hitung semua akun alumni
    final totalData = await supabase
      .from('user')
      .select('id_user');

    //hitung yang sudah isi tracer
    final alumniData = await supabase
      .from('alumni')
      .select('id_user');

    final int total = totalData.length;
    final int sudah = alumniData.length;
    final int belum = total - sudah;

    final bekerjaData = await supabase
    .from('alumni')
    .select('id_user')
    .eq('status_aktif', 'Bekerja');

    final kuliahData = await supabase
    .from('alumni')
    .select('id_user')
    .eq('status_aktif', 'Kuliah');

    final wirausahaData = await supabase
    .from('alumni')
    .select('id_user')
    .eq('status_aktif', 'Wirausaha');

    final lainnyaData = await supabase
    .from('alumni')
    .select('id_user')
    .eq('status_aktif', 'Lainnya');
    
    return {
      'total': total,
      'sudah': sudah, 
      'belum': belum,
      'bekerja': bekerjaData.length,
      'kuliah': kuliahData.length,
      'wirausaha': wirausahaData.length,
      'lainnya': lainnyaData.length,
    };


  }

  Widget _statistikItem(String judul, int jumlah) {
    return Column(
      children: [
        Text(judul, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8,),
        Text('$jumlah',
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
       ),
      ],
    );
  }

  //method kartu status
  Widget _kartuStatus(
    IconData icon,
    int jumlah,
    String judul,
    Color warna,
  ) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 25,
              color: const Color(0xFF28527A),
            ),
            const SizedBox(height: 8),
            Text(
              '$jumlah',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF28527A),
              ),
            ),
            Text(
              judul,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF28527A),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //header halo admin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF28527A),
                      ),
                    ),
                    const Text(
                      'Selamat datang di halaman admin',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                //Icon Notif
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color(0xFF28527A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            //kartu total alumni, belum mengisi, sudah mengisi
            FutureBuilder<Map<String, int>>(
              future: _statistikFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Text(
                    'Gagal mengambil statistik: ${snapshot.error}',
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('Data tidak ditemukan');
                }
                final data = snapshot.data!;

                return Column(
                  children: [
                    // Kartu total alumni
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28527A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _statistikItem(
                                    'Total Alumni',
                                    data['total']!,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 55,
                                  color: Colors.white54,
                                ),
                                Expanded(
                                  child: _statistikItem(
                                    'Sudah Mengisi',
                                    data['sudah']!,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 55,
                                  color: Colors.white54,
                                ),
                                Expanded(
                                  child: _statistikItem(
                                    'Belum Mengisi',
                                    data['belum']!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Baris kartu Bekerja dan Kuliah
                    Row(
                      children: [
                        Expanded(
                          child: _kartuStatus(
                            Icons.work,
                            data['bekerja']!,
                            'Bekerja',
                            const Color.fromARGB(255, 163, 202, 238),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _kartuStatus(
                            Icons.school,
                            data['kuliah']!,
                            'Kuliah',
                            const Color.fromARGB(255, 246, 244, 217),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Baris kartu Berwirausaha dan Lainnya
                    Row(
                      children: [
                        Expanded(
                          child: _kartuStatus(
                            Icons.business,
                            data['wirausaha']!,
                            'Berwirausaha',
                            const Color.fromARGB(255, 201, 231, 206),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _kartuStatus(
                            Icons.more_horiz,
                            data['lainnya']!,
                            'Lainnya',
                            const Color.fromARGB(255, 129, 166, 210),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

              //baris grafik 
              const SizedBox(height: 25),

              const Text('Statistik Status Alumni', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF28527A),),),
              const SizedBox(height: 12),

              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 213, 239, 255),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Grafik(),
              ),
          ]
        ),
      ),
     );
  }
}