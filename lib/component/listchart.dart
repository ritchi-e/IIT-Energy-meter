import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_responsive_dashboard_ui/config/responsive.dart';
import '../main.dart';

class DataPoint {
  final String field;
  final FlSpot spot;

  DataPoint(this.field, this.spot);
}


class LineChartComponent extends StatelessWidget {
  final List<MyDataModel> data;
   final List<String> fields;
  const LineChartComponent({Key? key, required this.data, required this.fields}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<DataPoint>> lineData = fields.map((field) {
      return data
          .where((entry) => entry.field == field)
          .map((entry) => DataPoint(entry.field, FlSpot(entry.start.millisecondsSinceEpoch.toDouble(), entry.value)))
         .toList();
    }).toList();
     
     print('Line Data:');
    for (int i = 0; i < lineData.length; i++) {
      final List<DataPoint> line = lineData[i];
      print('Line $i:');
      for (final point in line) {
        print('Field: ${point.field}, Spot: (${point.spot.x}, ${point.spot.y})');
      }
    }
    
    return LineChart(
      LineChartData(
        minX: data.isNotEmpty ? data.first.time.millisecondsSinceEpoch.toDouble() : 0,
        maxX: data.isNotEmpty ? data.last.time.millisecondsSinceEpoch.toDouble() : 0,
        minY: data.map((entry) => entry.value).reduce((a, b) => a < b ? a : b),
        maxY: data.map((entry) => entry.value).reduce((a, b) => a > b ? a : b),
          titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),

            getTitles: (value) => (value.toInt() + 1).toString(),
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        lineBarsData: lineData.map((line){
          return LineChartBarData(
            spots: line.map((point) => point.spot).toList(),
            isCurved: true,
            barWidth: 2,
            colors: [Color.fromRGBO(199, 128, 14, 1)],
            dotData: FlDotData(show: false),
          );
        }).toList(),
      ),
    );
  }
}

