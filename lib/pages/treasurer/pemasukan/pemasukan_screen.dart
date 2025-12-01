import 'package:flutter/material.dart';
import 'package:rukunin/pages/treasurer/pemasukan/pemasukan_form.dart';

class PemasukanScreen extends StatelessWidget {
  const PemasukanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Catat Pemasukan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: PemasukanForm(),
        ),
      ),
    );
  }
}
