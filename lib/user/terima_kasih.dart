import 'package:flutter/material.dart';

class TerimaKasihScreen extends StatelessWidget {
  const TerimaKasihScreen({super.key});

  void _kembali(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
           
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _kembali(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF244B73),
                    ),
                  ),
                ),
              ),
            ),

           
            Expanded(
              child: Align(
                alignment: const Alignment(0, -0.4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 165,
                      child: Image.asset(
                        'assets/images/terimakasih.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 36),
                    const Text(
                      'TERIMA KASIH!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Color(0xFF244B73),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Data Tracer Study Kamu\nTelah Berhasil Disimpan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xFF244B73),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // TOMBOL KEMBALI KE BERANDA
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 26, 12),
              child: SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  onPressed: () => _kembali(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD3E0F7),
                    foregroundColor: const Color(0xFF244B73),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke beranda',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}