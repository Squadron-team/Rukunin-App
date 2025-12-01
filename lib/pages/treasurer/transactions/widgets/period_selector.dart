import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({
    required this.onChanged,
    super.key,
    this.initialPeriod = 'Month',
  });

  final String initialPeriod;
  final ValueChanged<DateTimeRange> onChanged;

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  late String _selectedPeriod;
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.initialPeriod;
    // notify initial range after first frame
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onChanged(_periodRange()),
    );
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case 'Month':
        final monthNames = [
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
        return '${monthNames[_currentDate.month - 1]} ${_currentDate.year}';
      case 'Quarter':
        final quarter = ((_currentDate.month - 1) ~/ 3) + 1;
        return 'Triwulan $quarter ${_currentDate.year}';
      case 'Year':
        return 'Tahun ${_currentDate.year}';
      default:
        return '';
    }
  }

  String _getDateRangeLabel() {
    switch (_selectedPeriod) {
      case 'Month':
        final lastDay = DateTime(
          _currentDate.year,
          _currentDate.month + 1,
          0,
        ).day;
        return '1 - $lastDay ${_currentDate.month}/${_currentDate.year}';
      case 'Quarter':
        final quarter = ((_currentDate.month - 1) ~/ 3) + 1;
        final startMonth = (quarter - 1) * 3 + 1;
        final endMonth = startMonth + 2;
        return '$startMonth/${_currentDate.year} - $endMonth/${_currentDate.year}';
      case 'Year':
        return '1/1/${_currentDate.year} - 31/12/${_currentDate.year}';
      default:
        return '';
    }
  }

  DateTime _getPreviousPeriod() {
    switch (_selectedPeriod) {
      case 'Month':
        return DateTime(_currentDate.year, _currentDate.month - 1, 1);
      case 'Quarter':
        return DateTime(_currentDate.year, _currentDate.month - 3, 1);
      case 'Year':
        return DateTime(_currentDate.year - 1, _currentDate.month, 1);
      default:
        return _currentDate;
    }
  }

  DateTime _getNextPeriod() {
    switch (_selectedPeriod) {
      case 'Month':
        return DateTime(_currentDate.year, _currentDate.month + 1, 1);
      case 'Quarter':
        return DateTime(_currentDate.year, _currentDate.month + 3, 1);
      case 'Year':
        return DateTime(_currentDate.year + 1, _currentDate.month, 1);
      default:
        return _currentDate;
    }
  }

  bool _isCurrentPeriod() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'Month':
        return _currentDate.year == now.year && _currentDate.month == now.month;
      case 'Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final selectedQuarter = ((_currentDate.month - 1) ~/ 3) + 1;
        return _currentDate.year == now.year &&
            selectedQuarter == currentQuarter;
      case 'Year':
        return _currentDate.year == now.year;
      default:
        return true;
    }
  }

  DateTimeRange _periodRange() {
    switch (_selectedPeriod) {
      case 'Month':
        final start = DateTime(_currentDate.year, _currentDate.month, 1);
        final end = DateTime(_currentDate.year, _currentDate.month + 1, 0);
        return DateTimeRange(start: start, end: end);
      case 'Quarter':
        final quarter = ((_currentDate.month - 1) ~/ 3) + 1;
        final startMonth = (quarter - 1) * 3 + 1;
        final start = DateTime(_currentDate.year, startMonth, 1);
        final end = DateTime(_currentDate.year, startMonth + 3, 0);
        return DateTimeRange(start: start, end: end);
      case 'Year':
        final start = DateTime(_currentDate.year, 1, 1);
        final end = DateTime(_currentDate.year, 12, 31);
        return DateTimeRange(start: start, end: end);
      default:
        return DateTimeRange(start: DateTime(2000), end: DateTime.now());
    }
  }

  Widget _periodButton(String value, String label) {
    final isSelected = _selectedPeriod == value;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedPeriod = value;
        widget.onChanged(_periodRange());
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periode Laporan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _periodButton('Month', 'Bulanan')),
                Expanded(child: _periodButton('Quarter', 'Triwulan')),
                Expanded(child: _periodButton('Year', 'Tahunan')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    _currentDate = _getPreviousPeriod();
                    widget.onChanged(_periodRange());
                  }),
                  icon: const Icon(Icons.chevron_left_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _getPeriodLabel(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getDateRangeLabel(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _isCurrentPeriod()
                      ? null
                      : () => setState(() {
                          _currentDate = _getNextPeriod();
                          widget.onChanged(_periodRange());
                        }),
                  icon: const Icon(Icons.chevron_right_rounded),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: _isCurrentPeriod()
                        ? Colors.grey[200]
                        : Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
