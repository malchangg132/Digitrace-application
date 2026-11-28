import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InformasiAkunAdmin extends StatelessWidget {
  final String nama; 
  final String email; 

  const InformasiAkunAdmin({
    super.key,
    required this.nama, 
    required this.email, 
  });

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
              const SizedBox(height: 20),
              _buildKartuData(),
              const SizedBox(height: 24),
              _buildTombolKembali(context),
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

  // judul
  Widget _buildJudul() {
    return const Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        'Informasi Akun',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // card data
  Widget _buildKartuData() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header kartu
          const Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Data Pribadi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _BarisData(label: 'Nama Lengkap', nilai: nama), 
          _BarisData(label: 'Email', nilai: email), 
          const _BarisData(label: 'Role', nilai: 'Admin'),
        ],
      ),
    );
  }

  // icon back
  Widget _buildTombolKembali(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 34,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F0A0A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Kembali',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// label+nilai
class _BarisData extends StatelessWidget {
  final String label;
  final String nilai;

  const _BarisData({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 112,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  nilai,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5E5E5)),
      ],
    );
  }
}