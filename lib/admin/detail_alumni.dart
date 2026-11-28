import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailAlumni extends StatefulWidget {
  final Map<String, dynamic> alumni;

  const DetailAlumni({
    super.key,
    required this.alumni,
  });

  @override
  State<DetailAlumni> createState() => _DetailAlumniState();
}

class _DetailAlumniState extends State<DetailAlumni> {
  final supabase = Supabase.instance.client;

  late Future<Map<String, dynamic>?> _tracerFuture;

  @override
  void initState() {
    super.initState();
    _tracerFuture = _ambilTracerTerbaru();

    print('Data Alumni: ${widget.alumni}');
  }

  Future<void>_editBiodata() async {
    final tempatController = TextEditingController(
      text: widget.alumni['tempattanggal_lahir']?.toString() ?? '',
    );
    final tahunController = TextEditingController(
      text: widget.alumni['tahun_lulus']?.toString() ??'',
    );
    final kontakController = TextEditingController(
      text: widget.alumni['no_hp']?.toString() ?? '',
    );
    final alamatController = TextEditingController(
      text: widget.alumni['alamat_lengkap']?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Biodata ALumni'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tempatController,
                  decoration: const InputDecoration(
                    labelText: 'Tempat, Tanggal Lahir',
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tahun Lulus',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: kontakController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Kontak',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: alamatController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: ()async {
                  final tahun = tahunController.text.trim();
                  if (tahun.isNotEmpty && int.tryParse(tahun) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Tahun harus berupa angka'),
                      ),
                    );
                    return;
                  }

                  try {
                    await supabase
                    .from('alumni')
                    .update({
                      'tempattanggal_lahir':
                        tempatController.text.trim(),
                      'tahun_lulus':
                        tahun.isEmpty ? null :int.parse(tahun),
                      'no_hp': kontakController.text.trim(),
                      'alamat_lengkap':alamatController.text.trim(),
                    })
                    .eq('id', widget.alumni['id']);

                    widget.alumni['tempattanggal_lahir'] = tempatController.text.trim();
                    widget.alumni['tahun_lulus'] = tahun.isEmpty ? null : int.parse(tahun);
                    widget.alumni['no_hp'] = kontakController.text.trim();
                    widget.alumni['alamat_lengkap'] = alamatController.text.trim();

                    if (!mounted) return;

                    setState(() {
                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biodata Diperbarui'),),);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal perbarui biodata: $e'),),);
                  }
                },
                child: const Text('Simpan'),
                ),
          ],
        );
      },
    );

    tempatController.dispose();
    tahunController.dispose();
    kontakController.dispose();
    alamatController.dispose();
  }

  // Mengambil tracer study terbaru milik alumni
  Future<Map<String, dynamic>?> _ambilTracerTerbaru() async {
    final data = await supabase
        .from('tracer_study')
        .select()
        .eq('id_user', widget.alumni['id_user'])
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return data;
  }

  Future<List<Map<String, dynamic>>> _ambilSemuaTracer() async {
    final data = await supabase
      .from('tracer_study')
      .select()
      .eq('id_user', widget.alumni['id_user'])
      .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  //untuk hapus akun alumni
  Future<void> _hapusAkunAlumni() async {
    final konfirmasi = await showDialog<bool>(
      context:context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah kamu yakin menghapus akun ini?'
        '\nPenghapusan bersifat permanen'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), 
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context, true), 
          child: const Text('Hapus'),
        ),
      ]
    ),
   );

   if (konfirmasi != true) return;

   try {
    final idUser = widget.alumni['id_user'];

    //hapus semua riwayat
    await supabase
        .from('tracer_study')
        .delete()
        .eq('id_user', idUser);
    //hapus semua biodata
    await supabase
        .from('alumni')
        .delete()
        .eq('id_user', idUser);
    //hapus semua akun
    await supabase
        .from('user')
        .delete()
        .eq('id_user', idUser);

    if (!mounted) return; 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Akun telah dihapus'),),
    );
    Navigator.pop(context, true);      
   } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menghapus akun $e'),),
    );
   }
  }

  //untuk hapus riwayat
  Future<void>_hapusTracer(Map<String, dynamic> tracer) async {
    final konfirmasi = await showDialog<bool> (
      context:context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah kamu yakin menghapus riwayat ini?'
        '\nData yang dihapus tidak bisa dikembalikan'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), 
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context, true), 
          child: const Text('Hapus'),
        ),
      ],
     ),
    );

    if (konfirmasi != true) return;

    try {
      await supabase
      .from('tracer_study')
      .delete()
      .eq('id_tracer', tracer['id_tracer']);

      setState(() {
        _tracerFuture = _ambilTracerTerbaru();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Riwayat berhasil dihapus'),),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus riwayat: $e'),),
      );
    }
  }

  //untuk edit riwayat
  Future<void> _editTracer(Map<String, dynamic> tracer) async {
    final statusController = TextEditingController(text: tracer['status_aktif']?.toString() ?? '');
    final pendidikanController = TextEditingController(text: tracer['pendidikan_terakhir']?.toString() ?? '');
    final universitasController = TextEditingController(text: tracer['nama_universitas']?.toString() ?? '');
    final programController = TextEditingController(text: tracer['program_study']?.toString() ?? '');
    final tahunController = TextEditingController(text: tracer['tahun_masuk']?.toString() ?? '');
    final perusahaanController = TextEditingController(text: tracer['nama_perusahaan']?.toString() ?? '');
    final posisiController = TextEditingController(text: tracer['posisi_jabatan']?.toString() ?? '');
    final bidangController = TextEditingController(text: tracer['bidang_pekerjaan']?.toString() ?? '');
    final lokasiController = TextEditingController(text: tracer['lokasi_pekerjaan']?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Riwayat'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: statusController,
                  decoration: const InputDecoration(
                    labelText: 'Status Alumni',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: pendidikanController,
                  decoration: const InputDecoration(
                    labelText: 'Pendidikan Terakhir',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: universitasController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Universitas',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: programController,
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tahun Masuk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: perusahaanController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Perusahaan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: posisiController,
                  decoration: const InputDecoration(
                    labelText: 'Posisi/Jabatan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: bidangController,
                  decoration: const InputDecoration(
                    labelText: 'Bidang Pekerjaan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12,),
                TextField(
                  controller: lokasiController,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi Pekerjaan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), 
              child: const Text('Batal'),
              ),
            ElevatedButton(
              onPressed: () async {
                final tahun = tahunController.text.trim();

                if (tahun.isNotEmpty && int.tryParse(tahun) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tahun masuk berupa angka'),),
                    );
                    return;
                }
                try {
                  await supabase
                    .from('tracer_study')
                    .update({
                      'status_aktif': statusController.text.trim(),
                      'pendidikan_terakhir': pendidikanController.text.trim(),
                      'nama_universitas':universitasController.text.trim(),
                      'program_study': programController.text.trim(),
                      'tahun_masuk': tahun.isEmpty ? null : int.parse(tahun),
                      'nama_perusahaan': perusahaanController.text.trim(),
                      'posisi_jabatan' : posisiController.text.trim(),
                      'lokasi_pekerjaan' : lokasiController.text.trim(),
                    }).eq('id_tracer', tracer['id_tracer']);

                    if(!mounted) return;

                    setState(() {
                      _tracerFuture = _ambilTracerTerbaru();
                    });
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Riwayat diperbarui'),),
                      );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Gagal memperbarui: $e'),),
                    );
                }
              }, 
              child: const Text('Simpan'),
              ),
            ],
          );
      },
    );

    statusController.dispose();
    pendidikanController.dispose();
    universitasController.dispose();
    programController.dispose();
    tahunController.dispose();
    perusahaanController.dispose();
    posisiController.dispose();
    bidangController.dispose();
    lokasiController.dispose();
  }

  // Widget informasi biodata
  Widget _infoItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value == null || value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF28527A),
            ),
          ),
        ],
      ),
    );
  }

  // Widget judul bagian
  Widget _judulBagian(String judul) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        judul,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF28527A),
        ),
      ),
    );
  }

  // Menampilkan informasi pekerjaan atau pendidikan
  Widget _tampilanTracer(Map<String, dynamic>? tracer) {
    if (tracer == null) {
      return const Text(
        'Belum ada data tracer study.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }

    final status = tracer['status_aktif']?.toString() ?? '-';
    final statusLower = status.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoItem('Status Alumni', status),

        if (statusLower == 'bekerja' ||
            statusLower == 'wirausaha') ...[
          _infoItem(
            'Nama Instansi',
            tracer['nama_perusahaan']?.toString(),
          ),
          _infoItem(
            'Posisi',
            tracer['posisi_jabatan']?.toString(),
          ),
          _infoItem(
            'Bidang Pekerjaan',
            tracer['bidang_pekerjaan']?.toString(),
          ),
          _infoItem(
            'Lokasi Pekerjaan',
            tracer['lokasi_pekerjaan']?.toString(),
          ),
        ],

        if (statusLower == 'kuliah') ...[
          _infoItem(
            'Pendidikan Terakhir',
            tracer['pendidikan_terakhir']?.toString(),
          ),
          _infoItem(
            'Nama Universitas',
            tracer['nama_universitas']?.toString(),
          ),
          _infoItem(
            'Program Studi',
            tracer['program_study']?.toString(),
          ),
          _infoItem(
            'Tahun Masuk',
            tracer['tahun_masuk']?.toString(),
          ),
        ],

        if (statusLower != 'bekerja' &&
            statusLower != 'wirausaha' &&
            statusLower != 'kuliah') ...[
          _infoItem(
            'Pendidikan Terakhir',
            tracer['pendidikan_terakhir']?.toString(),
          ),
          _infoItem(
            'Nama Universitas',
            tracer['nama_universitas']?.toString(),
          ),
          _infoItem(
            'Nama Instansi',
            tracer['nama_perusahaan']?.toString(),
          ),
          _infoItem(
            'Posisi',
            tracer['posisi_jabatan']?.toString(),
          ),
        ],
      ],
    );
  }

  // Menampilkan daftar riwayat tracer study
  Widget _tampilanRiwayat(List<Map<String, dynamic>> riwayat) {
    if (riwayat.isEmpty) {
      return const Text(
        'Belum ada riwayat tracer study.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }

    return Column(
      children: riwayat.map((tracer) {
        final status = tracer['status_aktif']?.toString() ?? '-';
        final tanggal = tracer['created_at'] != null
            ? DateTime.parse(tracer['created_at'])
                .toLocal()
                .toString()
                .substring(0, 16)
            : '-';

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCCCCCC)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: 
                      Text(
                        'Status: $status',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF28527A),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _editTracer(tracer), 
                          icon: const Icon(Icons.edit, color: Color(0xFF28527A),),
                          tooltip: 'Edit Riwayat',
                          ),
                        IconButton(
                          onPressed: () => _hapusTracer(tracer), 
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Hapus Riwayat',
                          ),
                      ],
                    )
                    ],
                  ),

                  //tanggal pengisian
                  const SizedBox(height: 5),
                  Text(
                    'Tanggal pengisian: $tanggal',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Divider(),

                  //info pendidikan
                  if (status.toLowerCase() == 'kuliah') ...[
                    _infoItem(
                      'Universitas',
                      tracer['nama_universitas']?.toString(),
                    ),
                    _infoItem(
                      'Program Studi',
                      tracer['program_study']?.toString(),
                    ),
                    _infoItem(
                      'Tahun Masuk',
                      tracer['tahun_masuk']?.toString(),
                    ),
                  ] else if (status.toLowerCase() == 'bekerja' ||   //info pekerjaan
                      status.toLowerCase() == 'wirausaha') ...[
                    _infoItem(
                      'Nama Instansi',
                      tracer['nama_perusahaan']?.toString(),
                    ),
                    _infoItem(
                      'Posisi',
                      tracer['posisi_jabatan']?.toString(),
                    ),
                    _infoItem(
                      'Bidang Pekerjaan',
                      tracer['bidang_pekerjaan']?.toString(),
                    ),
                    _infoItem(
                      'Lokasi Pekerjaan',
                      tracer['lokasi_pekerjaan']?.toString(),
                    ),
                  ],
                ],
              ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nama =
        widget.alumni['user']?['nama_user']?.toString() ?? '-';

    // Status diambil dari tabel alumni, bukan tabel user
    final status =
        widget.alumni['status_aktif']?.toString() ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        title: const Text(
          'Detail Alumni',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF28527A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian profil alumni
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFB8C7DC),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF28527A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.alumni['tahun_lulus'] ?? '-'} - ${widget.alumni['jurusan'] ?? '-'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD5E5F7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                status.isEmpty ? '-' : status,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF28527A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Biodata alumni
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _judulBagian('Biodata Alumni'),
                            IconButton(
                              onPressed: _editBiodata, icon: Icon(Icons.edit, color: Color(0xFF28527A),),
                            tooltip: 'Edit Biodata',
                              ),
                          ],
                        ),

                        _infoItem(
                          'Tempat, Tanggal Lahir',
                          widget.alumni['tempattanggal_lahir']
                              ?.toString(),
                        ),
                        _infoItem(
                          'Tahun Lulus',
                          widget.alumni['tahun_lulus']?.toString(),
                        ),
                        _infoItem(
                          'Kontak',
                          widget.alumni['no_hp']?.toString(),
                        ),
                        _infoItem(
                          'Alamat',
                          widget.alumni['alamat_lengkap']?.toString(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Informasi pekerjaan atau pendidikan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _judulBagian(
                          'Informasi Pekerjaan / Pendidikan',
                        ),
                        FutureBuilder<Map<String, dynamic>?>(
                          future: _tracerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text(
                                'Gagal mengambil data: ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              );
                            }

                            return _tampilanTracer(snapshot.data);
                          },
                        ),

                        const SizedBox(height: 20,),
                        const Divider(),
                        _judulBagian('Riwayat Tracer Study'),

                        FutureBuilder<List<Map<String, dynamic>>>
                        (future: _ambilSemuaTracer(), builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: Padding(padding: EdgeInsets.all(15),
                              child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text('Gagal mengambil riwayat: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),);
                          }

                          
                          return _tampilanRiwayat(snapshot.data ?? []);
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),

            SizedBox(width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _hapusAkunAlumni, 
              icon: const Icon(Icons.delete),
              label: const Text('Hapus akun alumni'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),
              ),
            ),
           ),
          ],
        ),
      ),
    );
  }
}