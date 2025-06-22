import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardBarChart extends StatelessWidget {
  final List<BarChartItem> data;
  final double maxY;
  final double barWidth;

  const DashboardBarChart({
    super.key,
    required this.data,
    this.maxY = 20,
    this.barWidth = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: data.asMap().entries.map((entry) {
            int index = entry.key;
            BarChartItem item = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.value,
                  color: item.color ?? Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                  width: barWidth,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Text(data[index].label);
                  }
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BarChartItem {
  final String label;
  final double value;
  final Color? color;

  BarChartItem({
    required this.label,
    required this.value,
    this.color,
  });
}
