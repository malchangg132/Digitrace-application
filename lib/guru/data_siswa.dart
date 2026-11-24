
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
      home: const DataAlumniPage(),
    );
  }
}

class DataAlumniPage extends StatefulWidget {
  const DataAlumniPage({super.key});

  @override
  State<DataAlumniPage> createState() => _DataAlumniPageState();
}

class _DataAlumniPageState extends State<DataAlumniPage> {
  final Color primaryColor = const Color(0xFF284F78);

  int selectedIndex = 1;
  String selectedCategory = 'Semua';
  String searchQuery = '';

  final TextEditingController searchController =
      TextEditingController();

  final List<String> categories = [
    'Semua',
    'Bekerja',
    'Kuliah',
    'Wirausaha',
    'Lainnya',
  ];

  final List<Map<String, String>> alumni = [
    {'nama': 'Nadya Ulya', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Bekerja'},
    {'nama': 'Suendah', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Kuliah'},
    {'nama': 'Muhammad Irfan', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Bekerja'},
    {'nama': 'Adhon Panca', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Berwirausaha'},
    {'nama': 'Adzamar Mahdum', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Lainnya'},
    {'nama': 'Alvira Octiana', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Berwirausaha'},
    {'nama': 'Alya Nasmi', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Kuliah'},
    {'nama': 'Balqis Demes', 'tahun': '2019', 'jurusan': 'RPL', 'status': 'Kuliah'},
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Bekerja':
        return const Color(0xFFE3ECFF);
      case 'Kuliah':
        return const Color(0xFFFFF6D9);
      case 'Berwirausaha':
        return const Color(0xFFE7F1E0);
      default:
        return const Color(0xFFB0C0D0);
    }
  }

  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Bekerja':
        return const Color(0xFF284F78);
      case 'Kuliah':
        return Colors.blue;
      case 'Berwirausaha':
        return Colors.green.shade900;
      default:
        return const Color(0xFF284F78);
    }
  }

  List<Map<String, String>> get filteredAlumni {
    return alumni.where((data) {
      final matchesCategory =
          selectedCategory == 'Semua' ||
          data['status'] == selectedCategory ||
          (selectedCategory == 'Wirausaha' &&
              data['status'] == 'Berwirausaha');

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          data['nama']!.toLowerCase().contains(query) ||
          data['tahun']!.contains(query) ||
          data['jurusan']!.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 17),
                        Text(
                          'Data Alumni',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // SEARCH DAN FILTER
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 34,
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              style: const TextStyle(fontSize: 11),
                              decoration: InputDecoration(
                                hintText: 'Cari nama, NIS, atau jurusan',
                                hintStyle: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 16,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF91A9C4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          Icons.filter_alt_outlined,
                          color: primaryColor,
                          size: 22,
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // FILTER KATEGORI
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          bool isSelected =
                              selectedCategory == category;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 7),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 0.7,
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: isSelected
                                      ? Colors.white
                                      : primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // DAFTAR ALUMNI
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EFFF),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: filteredAlumni.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Center(
                                child: Text(
                                  'Data alumni tidak ditemukan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: filteredAlumni.map((data) {
                                return alumniCard(data);
                              }).toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        backgroundColor: const Color(0xFFF5F8F2),
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF6C879B),
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
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

  // WIDGET KARTU ALUMNI
  Widget alumniCard(Map<String, String> data) {
    String status = data['status']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // FOTO ALUMNI
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB5C9DC),
              border: Border.all(
                color: primaryColor,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.face_3,
              color: Colors.black87,
              size: 25,
            ),
          ),

          const SizedBox(width: 10),

          // IDENTITAS ALUMNI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['nama']!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${data['tahun']} - ${data['jurusan']}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // STATUS ALUMNI
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: getStatusColor(status),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9,
                color: getStatusTextColor(status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 14),
        ],
      ),
    );
  }
}
