import 'package:flutter/material.dart';
import 'package:rukunin/modules/community/widgets/finance_transparency_section.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';

class FinanceTransparencyScreen extends StatelessWidget {
  const FinanceTransparencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const RukuninAppBar(title: 'Transparansi Keuangan'),
      body: const FinanceTransparencySection(),
    );
  }
}
