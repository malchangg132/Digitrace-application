import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Grafik extends StatefulWidget {
  const Grafik({ Key? key }) : super(key: key);

  @override
  _GrafikState createState() => _GrafikState();
}

class _GrafikState extends State<Grafik> {

  final supabase = Supabase.instance.client;
  late Future<Map<String, int>> _dataGrafik;
  @override
    void initState() {
      super.initState();
      _dataGrafik = _ambilDataGrafik();
    }

  //mengambil jumlah alumni berdasarkan 4 status
  Future<Map<String, int>> _ambilDataGrafik() async {
    final bekerja = await supabase
        .from('alumni')
        .select('id_user')
        .eq('status_aktif', 'Bekerja');

    final kuliah = await supabase
        .from('alumni')
        .select('id_user')
        .eq('status_aktif', 'Kuliah');

    final wirausaha = await supabase
        .from('alumni')
        .select('id_user')
        .eq('status_aktif', 'Wirausaha');

    final lainnya = await supabase
        .from('alumni')
        .select('id_user')
        .eq('status_aktif', 'Lainnya');

    return {
      'bekerja': bekerja.length,
      'kuliah': kuliah.length,
      'wirausaha': wirausaha.length,
      'lainnya': lainnya.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
  future: _dataGrafik,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Text('Gagal mengambil data grafik: ${snapshot.error}');
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Text('Data grafik tidak ditemukan');
    }

    final data = snapshot.data!;

    final total = data['bekerja']! +
        data['kuliah']! +
        data['wirausaha']! +
        data['lainnya']!;

    double persentase(int jumlah) {
      if (total == 0) return 0;
      return jumlah / total * 100;
    }

    return Align(
  alignment: Alignment.centerLeft,
  child: SizedBox(
    height: 250,
    width: double.infinity,
    child: Row(
      children: [
        // Grafik lingkaran
        SizedBox(
          height: 250,
          width: 250,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sections: [
                PieChartSectionData(
                value: data['bekerja']!.toDouble(),
                color: const Color.fromARGB(255, 163, 202, 238),
                radius: 100,
              ),
              PieChartSectionData(
                value: data['kuliah']!.toDouble(),
                color: const Color.fromARGB(255, 246, 244, 217),
                radius: 100,
              ),
              PieChartSectionData(
                value: data['wirausaha']!.toDouble(),
                color: const Color.fromARGB(255, 201, 231, 206),
                radius: 100,
              ),
              PieChartSectionData(
                value: data['lainnya']!.toDouble(),
                color: const Color.fromARGB(255, 129, 166, 210),
                radius: 100,
              ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 15),

        // Tempat keterangan
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 163, 202, 238),
                      shape: BoxShape.rectangle
                    ),
                  ),

                  const SizedBox(width: 8),
                  const Text(
                      'Bekerja',
                      style: TextStyle(fontSize: 12),
                    ),
                  
                  const SizedBox(width: 50),
                    Text(
                    '${persentase(data['bekerja']!).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8,),
              //keterangan kuliah
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 244, 217),
                      shape: BoxShape.rectangle,
                    ),
                  ),

                  const SizedBox(width: 8,),
                  const Text('Kuliah',
                    style:TextStyle(fontSize: 12),
                    ),

                    const SizedBox(width: 57),
                    Text('${persentase(data['kuliah']!).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),)
                ],
              ),

              const SizedBox(height: 8,),

              //keterangan berwirausaha
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 201, 231, 206),
                      shape: BoxShape.rectangle
                    ),
                  ),

                  const SizedBox(width: 8,),
                  const Text('Berwirausaha',
                    style: TextStyle(fontSize: 12,),
                    ),
                  
                  const SizedBox(width: 15,),
                  Text('${persentase(data['wirausaha']!).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),),
                ],
              ),

              const SizedBox(height: 8,),

              //keterangan lainnya
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 129, 166, 210),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  const Text('Lainnya', style: TextStyle(fontSize: 12,),
                    ),

                  const SizedBox(width: 50,),
                  Text('${persentase(data['lainnya']!).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  ),
  );
  },
    );
  }
}