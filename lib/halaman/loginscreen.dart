import 'package:flutter/material.dart';
import 'package:digitrace/admin/bottombar.dart';
import 'package:digitrace/user/dashboard.dart';
import '../services/login_service.dart';
import '../services/sesi.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final LoginService _loginService = LoginService();

  bool _isPasswordHidden = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  // cek email dan password ke supabase, lalu pindah sesuai role
  Future<void> _masuk() async {
    final email = _emailC.text.trim();
    final password = _passwordC.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email dan password harus diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final hasil = await _loginService.masuk(email, password);
      if (!mounted) return;

      if (hasil == null) {
        setState(() => _isLoading = false);
        _showSnack('Email atau password salah');
        return;
      }

      // simpan siapa yang sedang login
      Sesi.akun = hasil;
      setState(() => _isLoading = false);

      if (hasil.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigasiAdmin()),
        );
      } else if (hasil.role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // role guru, halamannya belum dibuat
        _showSnack('Halaman guru belum tersedia');
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('Gagal login: $e');
      setState(() => _isLoading = false);
      _showSnack('Gagal masuk, coba lagi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Logo Digitrace
              Center(
                child: Image.asset(
                  'assets/images/logo2_digitrace.png',
                  width: 170,
                  height: 170,
                ),
              ),

              const SizedBox(height: 35),

              // Judul Login
              const Center(
                child: Text(
                  'Masuk Untuk Melanjutkan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Input Email
              TextField(
                controller: _emailC,
                decoration: InputDecoration(
                  hintText: 'Masukkan Email',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF999999),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Input Password
              TextField(
                controller: _passwordC,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  hintText: 'Masukkan Password',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF999999),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Tombol Masuk
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _masuk,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 14,
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
}