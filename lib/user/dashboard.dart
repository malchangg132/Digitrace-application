import 'package:flutter/material.dart';
import 'tracer.dart';
import 'profil.dart';
import 'notifikasi.dart';

// WARNA
const Color _kBlueDark = Color(0xFF264D7A);
const Color _kBlueSoft = Color(0xFFE6EDFB);
const Color _kMuted = Color(0xFF7D8BA3);
const Color _kSubText = Color(0xFF3F5E86);
const Color _kIconBg = Color(0xFFB4C3DC);

class _NotifItem {
  final IconData icon;
  final String title;
  final String desc;
  final String time;
  const _NotifItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.time,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // DATA DUMMY (nanti diganti data dari API)
  final String _nama = 'Endah';
  String _status = 'Mahasiswa';
  double _progress = 0.75;
  String _kampus = 'Universitas Malang';
  String _prodi = 'Teknik Informatika';
  List<String> _karierLines = ['Belum Bekerja'];
  String _terakhirDiperbarui = '25 september 2026';
  final int _navIndex = 0;

  final List<_NotifItem> _notifs = [
    _NotifItem(
      icon: Icons.campaign_outlined,
      title: 'Pengisian data tracer study periode 2026',
      desc: 'Yuk lengkapi data kamu sebelum 30 september 2026',
      time: '2 jam lalu',
    ),
    _NotifItem(
      icon: Icons.info_outline,
      title: 'Data tracer study berhasil diperbarui',
      desc: 'Data kamu berhasil disimpan pada 25 september 2026',
      time: '1 jam lalu',
    ),
    _NotifItem(
      icon: Icons.school_outlined,
      title: 'Status pendidikan kamu terverifikasi',
      desc: 'Admin sekolah telah memverifikasi data pendidikan kamu',
      time: 'Kemarin',
    ),
    _NotifItem(
      icon: Icons.campaign_outlined,
      title: 'Selamat datang di Digitrace',
      desc: 'Lengkapi profil kamu untuk memulai tracer study',
      time: '3 hari lalu',
    ),
  ];

  void _showSnack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void _onNavTap(int i) {
    if (i == 0) return; // sedang di Beranda
    _openTab(i);
  }

  // Dashboard jadi "pusat" navigasi tab. Halaman tab (Tracer/Profil) bisa
  // mengirim balik nomor tab lain (int) kalau user menekan navbar-nya,
  // atau TracerResult kalau form tracer selesai diisi.
  Future<void> _openTab(int i) async {
    Object? result;
    if (i == 1) {
      result = await Navigator.push<Object?>(
        context,
        MaterialPageRoute(builder: (_) => const TracerScreen()),
      );
    } else if (i == 3) {
      result = await Navigator.push<Object?>(
        context,
        MaterialPageRoute(builder: (_) => const ProfilScreen()),
      );
    } else {
      _showSnack('Halaman Riwayat belum tersedia');
      return;
    }

    if (!mounted) return;
    if (result is TracerResult) {
      _terapkanHasilTracer(result);
    } else if (result is int && result != i) {
      _openTab(result);
    }
  }

  String _formatTanggal(DateTime d) {
    const bulan = [
      'januari', 'februari', 'maret', 'april', 'mei', 'juni',
      'juli', 'agustus', 'september', 'oktober', 'november', 'desember',
    ];
    return '${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  // Perbarui dashboard dengan data hasil isian Tracer Study
  void _terapkanHasilTracer(TracerResult result) {
    final tgl = _formatTanggal(DateTime.now());
    setState(() {
      _status = _capitalize(result.status);
      _kampus = result.namaUniversitas;
      _prodi = result.programStudi;
      _karierLines = result.perusahaan.isNotEmpty
          ? [result.perusahaan, if (result.posisi.isNotEmpty) result.posisi]
          : ['Belum Bekerja'];
      _terakhirDiperbarui = tgl;
      _progress = 1.0;
      _notifs.insert(
        0,
        _NotifItem(
          icon: Icons.info_outline,
          title: 'Data tracer study berhasil diperbarui',
          desc: 'Data kamu berhasil disimpan pada $tgl',
          time: 'Baru saja',
        ),
      );
    });
  }

  // Buka halaman Notifikasi (icon ">" di kartu Notifikasi & Update).
  // Kalau di sana user menekan navbar, nomor tab-nya dikirim balik (int).
  Future<void> _showAllNotifs() async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(builder: (_) => const NotifikasiScreen()),
    );
    if (!mounted) return;
    if (result is int) _openTab(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildProgress(),
                    const SizedBox(height: 14),
                    _buildPendidikanKarier(),
                    const SizedBox(height: 14),
                    _buildTracer(),
                    const SizedBox(height: 14),
                    _buildNotifikasi(),
                    // banner ajakan hilang setelah data tracer lengkap
                    if (_progress < 1) ...[
                      const SizedBox(height: 14),
                      _buildBanner(),
                    ],
                  ],
                ),
              ),
            ),
            _BottomNav(selectedIndex: _navIndex, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }

  // ===== HEADER: sapaan + status + gambar wisuda =====
  Widget _buildHeader() {
    return SizedBox(
      height: 118,
      child: Stack(
        children: [
          Positioned(
            left: 4,
            top: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,\n$_nama!!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _kBlueDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 168,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F0E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school, size: 22, color: _kBlueDark),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status saat ini',
                            style: TextStyle(fontSize: 9, color: _kMuted),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _status,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _kBlueDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/images/logouser.png',
              width: 130,
              height: 118,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 130,
                height: 118,
                child: Icon(Icons.school, size: 60, color: _kIconBg),
              ),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE6F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, size: 16, color: _kBlueDark),
            ),
          ),
        ],
      ),
    );
  }

  // ===== PERJALANAN ALUMNI =====
  Widget _buildProgress() {
    return _Card(
      color: _kBlueSoft,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const _IconBox(icon: Icons.trending_up, bg: Color(0xFFC3D0E6)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Perjalanan Alumni',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kBlueDark,
                  ),
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _kBlueDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 14,
                backgroundColor: const Color(0xFFD0DAEC),
                valueColor: const AlwaysStoppedAnimation<Color>(_kBlueDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== PENDIDIKAN + KARIER =====
  Widget _buildPendidikanKarier() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _InfoCard(
              color: const Color(0xFFFEF9DE),
              iconBg: const Color(0xFFFBEFB5),
              icon: Icons.school,
              title: 'Pendidikan',
              lines: [_kampus, _prodi],
            ),
          ),
          const SizedBox(width: 36),
          Expanded(
            child: _InfoCard(
              color: _kBlueSoft,
              iconBg: const Color(0xFFD3DEF2),
              icon: Icons.work_outline,
              title: 'Karier',
              lines: _karierLines,
            ),
          ),
        ],
      ),
    );
  }

  // ===== TRACER STUDY =====
  Widget _buildTracer() {
    return _Card(
      color: const Color(0xFFD7E3F8),
      padding: const EdgeInsets.all(12),
      onTap: () => _onNavTap(1),
      child: Row(
        children: [
          const _IconBox(
            icon: Icons.description_outlined,
            bg: Color(0xFFAEBDD6),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tracer Study',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _kBlueDark,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Data terakhir diperbarui:',
                style: TextStyle(fontSize: 9, color: _kSubText),
              ),
              Text(
                _terakhirDiperbarui,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: _kBlueDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== NOTIFIKASI & UPDATE =====
  Widget _buildNotifikasi() {
    final preview = _notifs.take(2).toList();
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD3DAE6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _showAllNotifs,
            child: Container(
              height: 40,
              color: const Color(0xFFDDE5F2),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(
                children: [
                  Icon(Icons.notifications_none,
                      size: 20, color: _kBlueDark),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Notifikasi & Update',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _kBlueDark,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 22, color: _kBlueDark),
                ],
              ),
            ),
          ),
          for (int i = 0; i < preview.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 14,
                endIndent: 14,
                color: Color(0xFFDDE2EA),
              ),
            _NotifTile(item: preview[i], onTap: _showAllNotifs),
          ],
        ],
      ),
    );
  }

  // ===== BANNER AJAKAN =====
  Widget _buildBanner() {
    return _Card(
      color: _kBlueSoft,
      padding: const EdgeInsets.all(12),
      onTap: () => _onNavTap(1),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFB0BDD6),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ayo lengkapi data kamu!',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kBlueDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Bantu kami memantau perkembangan alumni dengan mengisi tracer study',
                  style: TextStyle(fontSize: 9.5, color: _kSubText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET PEMBANTU

class _Card extends StatelessWidget {
  final Color color;
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const _Card({
    required this.color,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final double size;

  const _IconBox({required this.icon, required this.bg, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(icon, size: size * 0.6, color: _kBlueDark),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final Color iconBg;
  final IconData icon;
  final String title;
  final List<String> lines;

  const _InfoCard({
    required this.color,
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      color: color,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBox(icon: icon, bg: iconBg, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _kBlueDark,
            ),
          ),
          const SizedBox(height: 4),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                l,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: _kSubText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final _NotifItem item;
  final VoidCallback? onTap;

  const _NotifTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _kIconBg,
              ),
              child: Icon(item.icon, size: 18, color: _kBlueDark),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _kBlueDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.desc,
                    style: const TextStyle(fontSize: 9, color: _kSubText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.time,
              style: const TextStyle(fontSize: 8.5, color: Color(0xFF3A4A66)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, 'Beranda'),
      (Icons.description_outlined, 'Tracer'),
      (Icons.history, 'Riwayat'),
      (Icons.person_outline, 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6F4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        border: Border.all(color: const Color(0xFFD5DBD8)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == selectedIndex;
              final color = selected
                  ? const Color(0xFF1B2B45)
                  : const Color(0xFF4F6F95);
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i].$1, size: 34, color: color),
                      const SizedBox(height: 2),
                      Text(
                        items[i].$2,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}