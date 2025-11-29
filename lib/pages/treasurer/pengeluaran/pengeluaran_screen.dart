import 'package:flutter/material.dart';
import 'pengeluaran_form.dart';

class PengeluaranScreen extends StatelessWidget {
  const PengeluaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Catat Pengeluaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: const PengeluaranForm(),
        ),
      ),
    );
  }
}
