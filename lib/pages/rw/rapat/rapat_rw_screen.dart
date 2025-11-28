import 'package:flutter/material.dart';

class RapatRwScreen extends StatelessWidget {
  const RapatRwScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rapat RW',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[50],
      body: const Center(child: Text('Halaman Rapat RW')),
    );
  }
}
