import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'tracer.dart';
import 'riwayat.dart';
import 'profil.dart';
import 'notifikasi.dart';

// bottombar
class BottombarUser extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottombarUser({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //mengatur menu yang aktif
      currentIndex: selectedIndex,
      onTap: onTap,

      //pengaturan tampilan button
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF2F6F4),
      selectedItemColor: const Color(0xFF1B2B45),
      unselectedItemColor: const Color(0xFF4F6F95),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      showUnselectedLabels: true,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          label: 'Tracer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}

// wadah
class NavigasiUser extends StatefulWidget {
  const NavigasiUser({super.key});

  @override
  State<NavigasiUser> createState() => _NavigasiUserState();
}

class _NavigasiUserState extends State<NavigasiUser> {
  int _selectedIndex = 0;

 
  final List<NotifData> _notifs = [];
  int _idNotif = 0; // nomor id notif berikutnya
  String _terakhirDiperbarui = '-'; // tanggal terakhir isi tracer (di sesi ini)

  // pindah tab, dipakai bottom bar dan tombol di dalam halaman
  void _pindahTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //ubah tanggal jadi tulisan, contoh: 25 november 2026
  String _formatTanggal(DateTime d) {
    const bulan = [
      'januari', 'februari', 'maret', 'april', 'mei', 'juni',
      'juli', 'agustus', 'september', 'oktober', 'november', 'desember',
    ];
    return '${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  // dipanggil setelah tracer berhasil disimpan
  void _tracerSelesai() {
    final tgl = _formatTanggal(DateTime.now());
    setState(() {
      _idNotif++;
      _notifs.insert(
        0,
        NotifData(
          id: _idNotif,
          title: 'Tracer Study Diperbarui',
          desc: 'Data Tracer study kamu telah berhasil disimpan. '
              'Terimakasih sudah melengkapi',
          tanggal: tgl,
        ),
      );
      _terakhirDiperbarui = tgl;
      _selectedIndex = 0; // kembali ke Beranda
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardScreen(
        onPindahTab: _pindahTab,
        terakhirDiperbarui: _terakhirDiperbarui, 
        notifs: _notifs,
      ),
      TracerScreen(
        onSelesai: (hasil) => _tracerSelesai(), 
      ),
      const RiwayatScreen(),
      const ProfilScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottombarUser(
        selectedIndex: _selectedIndex,
        onTap: _pindahTab,
      ),
    );
  }
}