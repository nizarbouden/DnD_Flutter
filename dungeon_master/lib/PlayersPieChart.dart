import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PlayersPieChart extends StatelessWidget {
  final int totalPlayers;
  final int onlinePlayers;

  PlayersPieChart({required this.totalPlayers, required this.onlinePlayers});

  @override
  Widget build(BuildContext context) {
    int offlinePlayers = totalPlayers - onlinePlayers;

    return Card(
      color: Colors.black.withOpacity(0.8), // Fond noir
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Players: $totalPlayers',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Expanded(
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: onlinePlayers.toDouble(),
                      color: Colors.green,
                      title: '${((onlinePlayers / totalPlayers) * 100).toStringAsFixed(1)}%',
                      titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: offlinePlayers.toDouble(),
                      color: Colors.red,
                      title: '${((offlinePlayers / totalPlayers) * 100).toStringAsFixed(1)}%',
                      titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                  sectionsSpace: 0,
                  startDegreeOffset: 180,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Legend(color: Colors.green, text: 'Online'),
                SizedBox(width: 10),
                Legend(color: Colors.red, text: 'Offline'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
