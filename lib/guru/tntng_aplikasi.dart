
import 'package:flutter/material.dart';

void main() {
  runApp(const DigitraceApp());
}

class DigitraceApp extends StatelessWidget {
  const DigitraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TentangAplikasiPage(),
    );
  }
}

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  final Color primaryColor = const Color(0xFF284F78);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // TOMBOL KEMBALI
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xFF284F78),
                  size: 21,
                ),
              ),

              const SizedBox(height: 25),

              // JUDUL
              Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 40),

              // LOGO DIGITRACE
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 42,
                      color: primaryColor,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'DIGITRACE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Tracer Study Alumni',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8BA2BD),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE5EF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Versi 1.0.0',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF71869B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // INFORMASI APLIKASI
              Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                width: 42,
                height: 1,
                color: primaryColor,
              ),

              const SizedBox(height: 7),

              // DESKRIPSI
              Text(
                'DIGITRACE adalah aplikasi tracer study yang membantu '
                'sekolah untuk mendata dan memantau perkembangan alumni '
                'setelah lulus, termasuk pendidikan lanjutan dan status pekerjaan.',
                style: TextStyle(
                  fontSize: 11,
                  color: primaryColor,
                  height: 2.1,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
