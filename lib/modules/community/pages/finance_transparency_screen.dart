import 'package:flutter/material.dart';
import 'package:rukunin/modules/community/widgets/finance_transparency_section.dart';

class FinanceTransparencyScreen extends StatelessWidget {
  const FinanceTransparencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Transparansi Keuangan',
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
      body: const FinanceTransparencySection(),
    );
  }
}
