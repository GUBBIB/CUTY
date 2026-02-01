import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DiagnosisRadarChart extends StatelessWidget {
  final List<int> data;
  final bool showLabels;

  const DiagnosisRadarChart({
    super.key,
    required this.data,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    // Data validation: ensure we have 5 data points
    final safeData = data.length >= 5 ? data.take(5).toList() : List.filled(5, 0);
    
    // Normalize data (assuming 0-100 range)
    // RadarChart requires RadarEntry list
    final entries = safeData.map((e) => RadarEntry(value: e.toDouble())).toList();

    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        radarBorderData: const BorderSide(color: Colors.transparent),
        tickBorderData: const BorderSide(color: Colors.transparent),
        gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        tickCount: 4,
        ticksTextStyle: const TextStyle(color: Colors.transparent),
        titlePositionPercentageOffset: 0.2, 
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 12),
        getTitle: (index, angle) {
          if (!showLabels) return const RadarChartTitle(text: '');
          const titles = ['직무적합도', '전공일치', '글로벌역량', '실무경험', '어학능력'];
          return RadarChartTitle(text: titles[index % titles.length]);
        },
        dataSets: [
          // User Data
          RadarDataSet(
            dataEntries: entries,
            fillColor: const Color(0xFF6200EE).withOpacity(0.4),
            borderColor: const Color(0xFF6200EE),
            entryRadius: 0,
            borderWidth: 2,
          ),
          // Placeholder for "Average" or "Full Score" if needed (optional)
        ],
      ),
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.linear,
    );
  }
}
