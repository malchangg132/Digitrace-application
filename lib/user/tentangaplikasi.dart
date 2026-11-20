import 'package:flutter/material.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF244B73),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Judul halaman
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  'Tentang Aplikasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF244B73),
                  ),
                ),
              ),
              const SizedBox(height: 42),

              // Logo, nama, dan versi
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 70,
                      child: Image.asset(
                        'assets/images/logo2_digitrace.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tracer Study Alumni',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9AA3B2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3DAE4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Versi 1.0.0',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF7D8BA3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Deskripsi aplikasi
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  'Tentang Aplikasi',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF244B73),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Container(
                  width: 45,
                  height: 1.5,
                  color: const Color(0xFF244B73),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'DIGITRACE adalah aplikasi tracer study yang membantu '
                  'sekolah untuk mendata dan memantau perkembangan alumni '
                  'setelah lulus, termasuk pendidikan lanjutan dan status '
                  'pekerjaan',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 2.1,
                    color: Color(0xFF244B73),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}