import 'package:flutter/material.dart';
import 'dash_admin.dart';
import 'data_alumni.dart';
import 'profil_admin.dart'; 

class Bottombar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const Bottombar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //mengatur menu yang aktif
      currentIndex: widget.selectedIndex,
      onTap: widget.onTap,
      
      //pengaturan tampilan button
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const  Color(0xFF28527A),
      unselectedItemColor: const Color.fromARGB(255, 169, 172, 173),
      showUnselectedLabels: true,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dataset),
          label: 'Data',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'laporan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

class NavigasiAdmin extends StatefulWidget {
  const NavigasiAdmin({super.key});

  @override
  State<NavigasiAdmin> createState() => _NavigasiAdminState();
}

class _NavigasiAdminState extends State<NavigasiAdmin> {
  int _selectedIndex = 0;
  late final List<Widget> _pages = [ 
    DashAdmin(),
    DataAlumni( 
      onBack: () {
        setState(() {
          _selectedIndex = 0; //kembali ke beranda
        });
      },
    ),
    const Center(child: Text('Halaman Laporan')),
    const ProfilAdmin(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
        bottomNavigationBar: Bottombar(
          selectedIndex: _selectedIndex,
           onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
           })
    );
  }
}