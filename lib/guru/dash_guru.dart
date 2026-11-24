
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
      home: const DashboardPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final Color primaryColor = const Color(0xFF284F78);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, Bu Jumanik',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const Text(
                        'Selamat datang di Digitrace',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.person,
                    size: 27,
                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // TOTAL ALUMNI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Total Alumni Terdaftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '1.248',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.groups,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // KATEGORI ALUMNI
              Row(
                children: [
                  Expanded(
                    child: categoryCard(
                      'Bekerja',
                      '642',
                      '51,4 %',
                      Icons.work_outline,
                      const Color(0xFFE6EDFF),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: categoryCard(
                      'Kuliah',
                      '438',
                      '35,1 %',
                      Icons.school,
                      const Color(0xFFFAF8E5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: categoryCard(
                      'Berwirausaha',
                      '92',
                      '7,7 %',
                      Icons.trending_up,
                      const Color(0xFFEDF4EA),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: categoryCard(
                      'Lainnya',
                      '72',
                      '5,8 %',
                      Icons.more_horiz,
                      const Color(0xFFAABBD0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 23),

              // GRAFIK
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3FF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grafik Perkembangan Alumni',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    const Divider(color: Colors.grey),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 145,
                            child: CustomPaint(
                              painter: PieChartPainter(),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              legendItem(
                                'Bekerja',
                                '51,4%',
                                const Color(0xFFD4E1F9),
                              ),
                              legendItem(
                                'Kuliah',
                                '35,1%',
                                const Color(0xFFF8F1C7),
                              ),
                              legendItem(
                                'Berwirausaha',
                                '7,7%',
                                const Color(0xFFD6E5C9),
                              ),
                              legendItem(
                                'Lainnya',
                                '5,8%',
                                const Color(0xFFAABBD0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
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
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF6C879B),
        backgroundColor: const Color(0xFFF7FAF5),
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
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

  // KARTU KATEGORI
  Widget categoryCard(
    String title,
    String total,
    String percentage,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 77,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: primaryColor.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 17,
            color: primaryColor,
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF284F78),
            ),
          ),
          Text(
            total,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 8,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // KETERANGAN GRAFIK
  Widget legendItem(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: primaryColor),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 8,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// PIE CHART
class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      2,
      2,
      size.width - 4,
      size.height - 4,
    );

    final values = [51.4, 5.8, 7.7, 35.1];

    final colors = [
      const Color(0xFFD4E1F9),
      const Color(0xFFAABBD0),
      const Color(0xFFD6E5C9),
      const Color(0xFFF8F1C7),
    ];

    double startAngle = -1.5708;

    for (int i = 0; i < values.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final sweepAngle = values[i] / 100 * 6.28318;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    final borderPaint = Paint()
      ..color = const Color(0xFF7893B1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawCircle(
      rect.center,
      rect.width / 2,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
