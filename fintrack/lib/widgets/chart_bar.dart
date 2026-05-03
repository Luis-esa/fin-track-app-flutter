import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';
import 'custom_text.dart';

class ChartBar extends StatelessWidget {
  final Map<int, double> data;
  final int year;

  const ChartBar({super.key, required this.data, required this.year});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox();
    }

    double maxY = 0;
    for (var v in data.values) {
      if (v > maxY) maxY = v;
    }
    
    // Add 20% padding to maxY
    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 100;

    final barGroups = data.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: AppConstants.primaryColor,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.title('Despesas em $year', fontSize: 18),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: AppConstants.textLightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        );
                        String text = '';
                        switch (value.toInt()) {
                          case 1: text = 'Jan'; break;
                          case 2: text = 'Fev'; break;
                          case 3: text = 'Mar'; break;
                          case 4: text = 'Abr'; break;
                          case 5: text = 'Mai'; break;
                          case 6: text = 'Jun'; break;
                          case 7: text = 'Jul'; break;
                          case 8: text = 'Ago'; break;
                          case 9: text = 'Set'; break;
                          case 10: text = 'Out'; break;
                          case 11: text = 'Nov'; break;
                          case 12: text = 'Dez'; break;
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
