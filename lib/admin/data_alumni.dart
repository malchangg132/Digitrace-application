import 'dart:ui';

import 'package:flutter/material.dart';

class DataAlumni extends StatefulWidget {
  const DataAlumni({ Key? key }) : super(key: key);

  @override
  _DataAlumniState createState() => _DataAlumniState();
}

class _DataAlumniState extends State<DataAlumni> {

  String _selectedFilter = 'Semua';
  //fungsi filter item
  Widget _filterItem(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
      },
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
          ? const Color(0xFF28527A)
          : Colors.white,
        border: Border.all(
          color: const Color(0xFF28527A),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title, 
      style: TextStyle(
        color: isSelected
        ? Colors.white
        : const Color(0xFF28527A)
        ),
       ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: Color(0xFF28527A),
                ),
                const SizedBox(width: 15,),
                const Text('Data Alumni',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF28527A),
                ),
               ),
              ],
             ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nama, NIS, atau jurusan',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                   ),
                   const SizedBox(width: 10,),
                   const Icon(Icons.filter_list, size: 28, color: Color(0xFF28527A),
                   ),
                ],
              ),
              ),

              // filter data alumni
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15,),
                child: Row(
                  children: [
                    const SizedBox(width: 8,),
                    _filterItem('Semua', true),

                    const SizedBox(width: 8,),
                    _filterItem('Bekerja', false),

                    const SizedBox(width: 8,),
                    _filterItem('Kuliah', false),

                    const SizedBox(width: 8,),
                    _filterItem('Wirausaha', false),
                    
                    const SizedBox(width: 8,),
                    _filterItem('Lainnya', false),
                  ],
                )
              ),
        ],
      ),
    );
  }
}