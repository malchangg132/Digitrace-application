import 'package:flutter/material.dart';

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