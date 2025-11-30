import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class FiltersRow extends StatefulWidget {
  final String periode;
  final String wilayah;
  final ValueChanged<String?> onPeriodeChanged;
  final ValueChanged<String?> onWilayahChanged;

  const FiltersRow({
    required this.periode,
    required this.wilayah,
    required this.onPeriodeChanged,
    required this.onWilayahChanged,
    super.key,
  });

  @override
  State<FiltersRow> createState() => _FiltersRowState();
}

class _FiltersRowState extends State<FiltersRow> {
  late String _selectedPeriode;
  DateTime _currentDate = DateTime.now();

  final monthNames = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPeriode = widget.periode;
  }

  void _setPeriode(String p) {
    setState(() {
      _selectedPeriode = p;
    });
    widget.onPeriodeChanged(p);
  }

  void _prev() {
    setState(() {
      if (_selectedPeriode == 'Bulanan') {
        _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
      } else if (_selectedPeriode == 'Triwulan')
        _currentDate = DateTime(_currentDate.year, _currentDate.month - 3, 1);
      else
        _currentDate = DateTime(_currentDate.year - 1, _currentDate.month, 1);
    });
  }

  void _next() {
    setState(() {
      if (_selectedPeriode == 'Bulanan') {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
      } else if (_selectedPeriode == 'Triwulan')
        _currentDate = DateTime(_currentDate.year, _currentDate.month + 3, 1);
      else
        _currentDate = DateTime(_currentDate.year + 1, _currentDate.month, 1);
    });
  }

  String _periodLabel() {
    if (_selectedPeriode == 'Bulanan') {
      return '${monthNames[_currentDate.month - 1]} ${_currentDate.year}';
    }
    if (_selectedPeriode == 'Triwulan') {
      final q = ((_currentDate.month - 1) ~/ 3) + 1;
      return 'Triwulan $q ${_currentDate.year}';
    }
    return '${_currentDate.year}';
  }

  String _periodRange() {
    if (_selectedPeriode == 'Bulanan') {
      final lastDay = DateTime(
        _currentDate.year,
        _currentDate.month + 1,
        0,
      ).day;
      return '1 - $lastDay ${_currentDate.month}/${_currentDate.year}';
    }
    if (_selectedPeriode == 'Triwulan') {
      final q = ((_currentDate.month - 1) ~/ 3) + 1;
      final startMonth = ((q - 1) * 3) + 1;
      final endMonth = startMonth + 2;
      return '$startMonth/${_currentDate.year} - $endMonth/${_currentDate.year}';
    }
    return '1/1/${_currentDate.year} - 31/12/${_currentDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Periode Laporan',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _setPeriode('Bulanan'),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedPeriode == 'Bulanan'
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Bulanan',
                      style: TextStyle(
                        color: _selectedPeriode == 'Bulanan'
                            ? Colors.white
                            : Colors.grey[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _setPeriode('Triwulan'),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedPeriode == 'Triwulan'
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Triwulan',
                      style: TextStyle(
                        color: _selectedPeriode == 'Triwulan'
                            ? Colors.white
                            : Colors.grey[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _setPeriode('Tahunan'),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedPeriode == 'Tahunan'
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Tahunan',
                      style: TextStyle(
                        color: _selectedPeriode == 'Tahunan'
                            ? Colors.white
                            : Colors.grey[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              InkWell(
                onTap: _prev,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _periodLabel(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _periodRange(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _next,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
