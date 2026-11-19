import 'package:flutter/material.dart';
import 'package:digitrace/admin/dash_admin.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _isPasswordHidden = true;

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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashAdmin(),
                      ),
                    );
                  },
                  child: const Text(
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
