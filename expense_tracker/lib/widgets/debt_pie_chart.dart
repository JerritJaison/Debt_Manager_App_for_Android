import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/debt.dart';

class DebtPieChart extends StatelessWidget {
  final List<Debt> debts;
  const DebtPieChart({super.key, required this.debts});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> dataMap = {};

    for (var debt in debts) {
      dataMap.update(debt.category, (value) => value + debt.remainingAmount,
          ifAbsent: () => debt.remainingAmount);
    }

    if (dataMap.isEmpty) {
      return const Center(
        child: Text(
          'No data to display',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    final sections = dataMap.entries.map((entry) {
      final color = _colorForCategory(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Color _colorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'travel':
        return Colors.blue;
      case 'shopping':
        return Colors.pink;
      case 'education':
        return Colors.green;
      case 'bills':
        return const Color.fromARGB(255, 243, 243, 33);
      case 'entertainment':
        return const Color.fromARGB(255, 2, 64, 115);
      case 'credid card':
        return const Color.fromARGB(255, 252, 0, 0);
      case 'health':
        return const Color.fromARGB(255, 140, 24, 167);
      default:
        return Colors.purpleAccent;
    }
  }
}
