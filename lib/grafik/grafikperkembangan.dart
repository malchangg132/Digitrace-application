import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Grafik extends StatefulWidget {
  const Grafik({ Key? key }) : super(key: key);

  @override
  _GrafikState createState() => _GrafikState();
}

class _GrafikState extends State<Grafik> {
  @override
  Widget build(BuildContext context) {
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
                  value: 120,
                  color: const Color.fromARGB(255, 163, 202, 238),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: 80,
                  color: const Color.fromARGB(255, 246, 244, 217),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: 50,
                  color: const Color.fromARGB(255, 201, 231, 206),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: 20,
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
                    const Text(
                    '48%',
                    style: TextStyle(
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
                  const Text('32%', 
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                 ),
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
                   const Text('12%',
                   style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                   ),
                  ),
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
                   const Text('8%',
                   style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                   ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  ),
);
  }
}