
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
      home: const ProfilGuruPage(),
    );
  }
}

class ProfilGuruPage extends StatefulWidget {
  const ProfilGuruPage({super.key});

  @override
  State<ProfilGuruPage> createState() => _ProfilGuruPageState();
}

class _ProfilGuruPageState extends State<ProfilGuruPage> {
  int selectedIndex = 2;

  final Color primaryColor = const Color(0xFF284F78);
  final Color redColor = const Color(0xFF790900);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // JUDUL
              Text(
                'Profil Guru',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 17),

              // KARTU PROFIL GURU
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 53,
                      color: Colors.black,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jumanik, S.Pd',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Row(
                            children: [
                              Icon(
                                Icons.work,
                                size: 13,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Guru Ipas',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 3),

                          Row(
                            children: [
                              Icon(
                                Icons.contact_phone,
                                size: 13,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '009345678224',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCE7FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Guru',
                          style: TextStyle(
                            fontSize: 9,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // MENU PROFIL
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    menuItem(
                      Icons.person,
                      'Ubah Profil',
                      'Atur Akun anda',
                      () {
                        showMessage('Menu Ubah Profil');
                      },
                    ),

                    const Divider(height: 12),

                    menuItem(
                      Icons.info,
                      'Tentang Aplikasi',
                      'Informasi Aplikasi',
                      () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Digitrace',
                          applicationVersion: '1.0.0',
                          applicationLegalese:
                              'Aplikasi pendataan dan tracer study alumni.',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // TOMBOL LOGOUT
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                          'Apakah Anda yakin ingin keluar?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showMessage('Silakan hubungkan ke halaman Login');
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 17),
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFFF3F7EF),
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF6C879B),
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // WIDGET MENU
  Widget menuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFFE6EEFA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 13,
                color: const Color(0xFF607F9F),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF284F78),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              size: 17,
              color: Color(0xFF284F78),
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
