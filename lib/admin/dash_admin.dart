import 'package:flutter/material.dart';
import '../grafik/grafikperkembangan.dart';

class DashAdmin extends StatefulWidget {
  const DashAdmin({ Key? key }) : super(key: key);

  @override
  _DashAdminState createState() => _DashAdminState();
}

class _DashAdminState extends State<DashAdmin> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //header halo admin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF28527A),
                      ),
                    ),
                    const Text(
                      'Selamat datang di halaman admin',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                //Icon Notif
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color(0xFF28527A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            //kartu total alumni bagian kiri
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF28527A),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bagian kiri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total Alumni Terdaftar',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '250',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Alumni terdaftar di Digitrace',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                // Bagian kanan: Icon
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
            ),
            const SizedBox(height: 15),

            //baris kartu atas
            Row(
              children: [
                //kartu kerja
                Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 163, 202, 238),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding (
                      padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.work, size: 25, color: Color(0xFF28527A),),
                        const SizedBox(height: 8),
                        const Text('120', 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF28527A),),),
                        const Text('Bekerja', 
                        style: TextStyle(fontSize: 12,color: Color(0xFF28527A),),),
                      ],
                    ),
                    ),
                  ),
                ),

                //kartu kuliah
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 246, 244, 217),
                  borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.school, size: 25, color: Color(0xFF28527A),),
                        const SizedBox(height: 8),
                        const Text('80', 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF28527A),),),
                        const Text('Kuliah',
                        style: TextStyle(fontSize: 12,color: Color(0xFF28527A),),),
                      ],
                    ),
                  ),
                ),
              ),
             ],
            ),
              
              //baris kartu kedua
              const SizedBox(height: 15),
                
              Row(
                children: [
                  //kartu berwirausaha
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 201, 231, 206),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.business, size: 25, color: Color(0xFF28527A),),
                            const SizedBox(height: 8),
                            const Text('92', 
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF28527A),),),
                            const Text('Berwirausaha',
                            style: TextStyle(fontSize: 12,color: Color(0xFF28527A),),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  //kartu lainnya
                  Expanded(
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 129, 166, 210),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.more_horiz, size: 25, color: Color(0xFF28527A),),
                            const SizedBox(height: 8),
                            const Text('72', 
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF28527A),),),
                            const Text('Lainnya',
                            style: TextStyle(fontSize: 12,color: Color(0xFF28527A),),)
                          ],
                        ),
                    ),
                  ),
                 ),
                ],
              ),

              //baris grafik 
              const SizedBox(height: 25),

              const Text('Statistik Status Alumni', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF28527A),),),
              const SizedBox(height: 12),

              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 213, 239, 255),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Grafik(),
              ),
          ]
        ),
      ),
     );
  }
}