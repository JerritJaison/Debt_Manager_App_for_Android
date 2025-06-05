import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  const ExpensePieChart({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: dataMap.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value,
            title: '${entry.key}: ${entry.value.toStringAsFixed(0)}₹',
            color: Colors.primaries[
                dataMap.keys.toList().indexOf(entry.key) %
                    Colors.primaries.length],
            radius: 60,
            titleStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
        sectionsSpace: 4,
        centerSpaceRadius: 40,
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}
