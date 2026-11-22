import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'data_alumni.dart';

class DetailAlumniScreen extends StatelessWidget {
  final Alumni alumni;
  const DetailAlumniScreen({super.key, required this.alumni});

  // dialog konfirmasi sebelum hapus data
  Future<void> _konfirmasiHapus(BuildContext context) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Data'),
        content: Text('Yakin ingin menghapus data ${alumni.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFA50E0E)),
            ),
          ),
        ],
      ),
    );
    if (ya == true && context.mounted) {
      // TODO: hapus data di supabase di sini
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildHeader(context),
            const SizedBox(height: 14),
            _buildIsi(),
            _buildTombolHapus(context),
          ],
        ),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 18),
          const Text(
            'Detail Alumni',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ===== ISI (kotak biru muda) =====
  Widget _buildIsi() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 36, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfil(),
              const SizedBox(height: 22),
              _buildInfoPribadi(),
              const SizedBox(height: 16),
              _buildInfoPekerjaan(),
            ],
          ),
        ),
      ),
    );
  }

  // ===== PROFIL: foto, nama, angkatan, status =====
  Widget _buildProfil() {
    final style = StatusStyle.of(alumni.status);
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Row(
        children: [
          //foto profil sementara pakai ikon
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6B6B6B),
              border: Border.all(color: const Color(0xFFBDBDBD), width: 4),
            ),
            child: const Icon(
              Icons.person,
              size: 38,
              color: Color(0xFFE6E6E6),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alumni.nama,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${alumni.angkatan} - ${alumni.jurusan.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 4),
              //badge status
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: style.bg,
                  borderRadius: BorderRadius.circular(3),
                  border:
                      Border.all(color: const Color(0xFFA9BEE0), width: 0.8),
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
            ],
          ),
        ],
      ),
    );
  }

  // ===== KARTU INFO PRIBADI =====
  Widget _buildInfoPribadi() {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(22, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.location_on,
            label: 'Tempat, Tanggal lahir',
            value: alumni.tempatTglLahir,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.event_note_outlined,
            label: 'Tanggal Lulus',
            value: alumni.tglLulus,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.phone,
            label: 'Kontak',
            value: alumni.kontak,
            extra: alumni.email,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.other_houses_outlined,
            label: 'Alamat',
            value: alumni.alamat,
          ),
        ],
      ),
    );
  }

  // ===== KARTU INFORMASI PEKERJAAN =====
  Widget _buildInfoPekerjaan() {
    return _WhiteCard(
      padding: const EdgeInsets.fromLTRB(30, 28, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pekerjaan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Nama instansi',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            alumni.namaInstansi,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Posisi',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          Text(
            alumni.posisi,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mulai Bekerja',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            alumni.mulaiBekerja,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===== TOMBOL HAPUS DATA =====
  Widget _buildTombolHapus(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border.all(color: const Color(0xFFD5DBD8)),
      ),
      child: SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () => _konfirmasiHapus(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA50E0E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Hapus Data',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// WIDGET PEMBANTU

// kartu putih dengan garis tepi abu
class _WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _WhiteCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBFC3CA), width: 1),
      ),
      child: child,
    );
  }
}

// satu baris info: ikon + label + isi
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? extra; // email (digarisbawahi)

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8795AD),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (extra != null) ...[
                const SizedBox(height: 4),
                Text(
                  extra!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}