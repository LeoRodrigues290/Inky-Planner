
import 'package:flutter/material.dart';
import 'package:myapp/data/models/daily_log_model.dart';
import 'package:pie_chart/pie_chart.dart'; // You need to add this package

class MacrosSummaryCard extends StatelessWidget {
  final DailyLog dailyLog;

  const MacrosSummaryCard({super.key, required this.dailyLog});

  @override
  Widget build(BuildContext context) {
    final macrosMap = {
      'Protein': dailyLog.totalProtein.toDouble(),
      'Carbs': dailyLog.totalCarbs.toDouble(),
      'Fats': dailyLog.totalFats.toDouble(),
    };

    // Handle case where all macros are zero to avoid PieChart errors
    final isDataAvailable = macrosMap.values.any((v) => v > 0);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Daily Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(
              '${dailyLog.totalCalories.toStringAsFixed(0)} kcal',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 24),
            if (isDataAvailable)
              PieChart(
                dataMap: macrosMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                colorList: const [Colors.blue, Colors.green, Colors.red],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: "Macros",
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              )
            else
              const Text('Log foods to see macro distribution'),
          ],
        ),
      ),
    );
  }
}
