import 'package:flutter/material.dart';

class DashAdmin extends StatefulWidget {
  const DashAdmin({ Key? key }) : super(key: key);

  @override
  _DashAdminState createState() => _DashAdminState();
}

class _DashAdminState extends State<DashAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}