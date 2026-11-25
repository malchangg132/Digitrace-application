import 'package:flutter/material.dart';
import 'notifikasi.dart';
import '../services/sesi.dart'; 
import '../services/tracer_service.dart'; 


class DashboardScreen extends StatefulWidget {
  // fungsi pindah tab, tanggal terakhir diperbarui, dan daftar notif, dikirim dari NavigasiUser
  final Function(int) onPindahTab;
  final String terakhirDiperbarui;
  final List<NotifData> notifs; 

  const DashboardScreen({
    super.key,
    required this.onPindahTab,
    required this.terakhirDiperbarui,
    required this.notifs,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  // nilai awal dikosongkan, diisi dari supabase lewat _muatData()
  String _nama = '';
  String _status = '-';
  double _progress = 0;
  String _kampus = '-';
  String _prodi = '-';
  List<String> _karierLines = ['Belum Bekerja'];

  // terakhirDiperbarui dan list _notifs dihapus (sekarang dari widget)

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  //ambil data alumni yang sedang login dari supabase
  Future<void> _muatData() async {
    final akun = Sesi.akun;
    if (akun == null) return;

    try {
      final tracer = await TracerService().ambil(akun.id);
      if (!mounted) return;
      setState(() {
        _nama = akun.nama;
        if (tracer != null) {
          _status = _capitalize(tracer.statusAktif ?? '-');
          _kampus = tracer.namaUniversitas ?? '-';
          _prodi = tracer.programStudy ?? '-';
          _karierLines = (tracer.namaPerusahaan ?? '').isNotEmpty
              ? [
                  tracer.namaPerusahaan!,
                  if ((tracer.posisiJabatan ?? '').isNotEmpty)
                    tracer.posisiJabatan!,
                ]
              : ['Belum Bekerja'];
          _progress = 1.0;
        } else {
          // belum pernah isi tracer study
          _progress = 0.25;
        }
      });
    } catch (e) {
      debugPrint('Gagal ambil data dashboard: $e');
    }

    // <-- UBAH: bagian hasilTracer dihapus, data sudah diambil dari supabase di atas
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  //formatTanggal dan _terapkanHasilTracer dipindah ke NavigasiUser

  // buka halaman notifikasi (icon ">" di kartu Notifikasi & Update).
  // setelah kembali, refresh supaya notif yang dihapus hilang dari preview
  Future<void> _showAllNotifs() async { // <-- UBAH: jadi async
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotifikasiScreen(items: widget.notifs), // <-- UBAH
      ),
    );
    if (!mounted) return;
    setState(() {});
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
          ],
        ),
      ),
    );
  }

  //sapaan + status + gambar wisuda =====
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
                    color: Color(0xFF244B73),
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
                      const Icon(
                        Icons.school,
                        size: 22,
                        color: Color(0xFF244B73),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status saat ini',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF7D8BA3),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _status,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF244B73),
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
              child: const Icon(
                Icons.school,
                size: 16,
                color: Color(0xFF244B73),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //perjalanan alumni
  Widget _buildProgress() {
    return _Card(
      color: const Color(0xFFE6EDFB),
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
                    color: Color(0xFF244B73),
                  ),
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF244B73),
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
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF244B73),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //pendidikan dan karier
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
              color: const Color(0xFFE6EDFB),
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

  // tracer study
  Widget _buildTracer() {
    return _Card(
      color: const Color(0xFFD7E3F8),
      padding: const EdgeInsets.all(12),
      onTap: () => widget.onPindahTab(1),
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
                  color: Color(0xFF244B73),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Data terakhir diperbarui:',
                style: TextStyle(fontSize: 9, color: Color(0xFF3F5E86)),
              ),
              Text(
                widget.terakhirDiperbarui, 
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF244B73),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // notifikasi dan update
  Widget _buildNotifikasi() {
    final preview = widget.notifs.take(2).toList(); // <-- UBAH
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
                  Icon(
                    Icons.notifications_none,
                    size: 20,
                    color: Color(0xFF244B73),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Notifikasi & Update',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF244B73),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 22,
                    color: Color(0xFF244B73),
                  ),
                ],
              ),
            ),
          ),
          //tulisan kalau belum ada notifikasi
          if (preview.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Belum ada notifikasi',
                style: TextStyle(fontSize: 10, color: Color(0xFF8793A8)),
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

  // banner ajakan
  Widget _buildBanner() {
    return _Card(
      color: const Color(0xFFE6EDFB),
      padding: const EdgeInsets.all(12),
      onTap: () => widget.onPindahTab(1), 
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
                    color: Color(0xFF244B73),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Bantu kami memantau perkembangan alumni dengan mengisi tracer study',
                  style: TextStyle(fontSize: 9.5, color: Color(0xFF3F5E86)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


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
      child: Icon(icon, size: size * 0.6, color: const Color(0xFF244B73)),
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
              color: Color(0xFF244B73),
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
                  color: Color(0xFF3F5E86),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotifData item; // <-- UBAH
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
                color: Color(0xFFB4C3DC),
              ),
              // <-- UBAH: ikon tetap, karena NotifData tidak punya field icon
              child: const Icon(
                Icons.info_outline,
                size: 18,
                color: Color(0xFF244B73),
              ),
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
                      color: Color(0xFF244B73),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.desc,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF3F5E86),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.tanggal, // <-- UBAH: gantinya item.time
              style: const TextStyle(fontSize: 8.5, color: Color(0xFF3A4A66)),
            ),
          ],
        ),
      ),
    );
  }
}