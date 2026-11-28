import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TentangAplikasiAdmin extends StatelessWidget {
  const TentangAplikasiAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPanahKembali(context),
              const SizedBox(height: 24),
              _buildJudul(),
              const SizedBox(height: 28),
              _buildLogo(),
              const SizedBox(height: 28),
              _buildDeskripsi(),
            ],
          ),
        ),
      ),
    );
  }

  // back
  Widget _buildPanahKembali(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(Icons.arrow_back, size: 22, color: AppColors.primary),
      ),
    );
  }

  // jdul
  Widget _buildJudul() {
    return const Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        'Tentang Aplikasi',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // logo+vers
  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          //logo digitrace
          Image.asset(
            'assets/images/logo2_digitrace.png',
            width: 110,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.school,
                size: 70,
                color: AppColors.primary,
              );
            },
          ),
          const SizedBox(height: 4),
          const Text(
            'Tracer Study Alumni',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD5DCE6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // deskrip
  Widget _buildDeskripsi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tentang Aplikasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          //garis bawah pendek
          const SizedBox(height: 4),
          Container(width: 56, height: 1, color: AppColors.primary),
          const SizedBox(height: 14),
          const Text(
            'DIGITRACE adalah aplikasi tracer study yang membantu sekolah '
            'untuk mendata dan memantau perkembangan alumni setelah lulus, '
            'termasuk pendidikan lanjutan dan status pekerjaan',
            style: TextStyle(
              fontSize: 11,
              height: 2.2,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}