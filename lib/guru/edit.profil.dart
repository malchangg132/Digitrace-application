
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
      home: const EditProfilPage(),
    );
  }
}

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final Color primaryColor = const Color(0xFF284F78);
  final Color redColor = const Color(0xFF800900);

  bool obscurePassword = true;

  final TextEditingController namaController =
      TextEditingController(text: 'Jumanik');

  final TextEditingController jabatanController =
      TextEditingController(text: 'Guru Ipas');

  final TextEditingController nipController =
      TextEditingController(text: '009345678824');

  final TextEditingController passwordController =
      TextEditingController(text: '12345678');

  @override
  void dispose() {
    namaController.dispose();
    jabatanController.dispose();
    nipController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // TOMBOL KEMBALI
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              const SizedBox(height: 22),

              // JUDUL
              Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 24),

              // KARTU DATA PRIBADI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER DATA PRIBADI
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: primaryColor,
                          size: 19,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          'Data Pribadi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    // NAMA LENGKAP
                    profileRow(
                      'Nama Lengkap',
                      namaController,
                    ),

                    // JABATAN
                    profileRow(
                      'Jabatan',
                      jabatanController,
                    ),

                    // NIP
                    profileRow(
                      'NIP',
                      nipController,
                    ),

                    // PASSWORD
                    Row(
                      children: [
                        SizedBox(
                          width: 112,
                          child: Text(
                            'Password akun',
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryColor,
                            ),
                          ),
                        ),

                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        // TAMPILKAN PASSWORD
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          child: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 17,
                            color: primaryColor,
                          ),
                        ),

                        const SizedBox(width: 7),

                        // EDIT PASSWORD
                        GestureDetector(
                          onTap: () {
                            showPasswordDialog();
                          },
                          child: Icon(
                            Icons.edit_outlined,
                            size: 17,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const Divider(
                      height: 15,
                      color: Color(0xFFE0E0E0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    saveProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET BARIS PROFIL
  Widget profileRow(
    String title,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 112,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: primaryColor,
                ),
              ),
            ),

            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),

        const Divider(
          height: 15,
          color: Color(0xFFE0E0E0),
        ),
      ],
    );
  }

  // DIALOG EDIT PASSWORD
  void showPasswordDialog() {
    final controller = TextEditingController(
      text: passwordController.text,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Ubah Password',
            style: TextStyle(fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  passwordController.text = controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // SIMPAN PROFIL
  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data profil berhasil disimpan!'),
      ),
    );
  }
}
