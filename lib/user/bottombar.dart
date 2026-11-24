import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'tracer.dart';
import 'riwayat.dart';
import 'profil.dart';

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

  // hasil isian tracer, disimpan di sini supaya bisa dikirim ke dashboard
  TracerResult? _hasilTracer;

  // pindah tab, dipakai bottom bar dan tombol di dalam halaman
  void _pindahTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardScreen(onPindahTab: _pindahTab, hasilTracer: _hasilTracer),
      TracerScreen(
        onSelesai: (hasil) {
          setState(() {
            _hasilTracer = hasil;
            _selectedIndex = 0; // kembali ke Beranda
          });
        },
      ),
      // dummy
      const RiwayatScreen(
        data: RiwayatData(
          pendidikanTerakhir: '-',
          namaUniversitas: '-',
          programStudi: '-',
          tahunMasuk: '-',
          statusPendidikan: '-',
          statusKerja: '-',
          namaPerusahaan: '-',
          posisi: '-',
          bidang: '-',
          lokasi: '-',
        ),
      ),
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