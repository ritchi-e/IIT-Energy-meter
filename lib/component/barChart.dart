// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_responsive_dashboard_ui/config/responsive.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';

import '../main.dart';


class BarChartCopmponent extends StatelessWidget {
  final List<MyDataModel> data; // Add this line to receive the data

  const BarChartCopmponent({
    required Key key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<List<MyDataModel>>(
      future: loadCSVData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MyDataModel> parsedData = snapshot.data!;
          // Prepare the data for the bar chart
         

         List<BarChartGroupData> barChartGroups = parsedData.where((data) => data.field == "Freq").map((data) {
          return BarChartGroupData(
           x: parsedData.indexOf(data),
           barRods: [
           BarChartRodData(
            y: data.value,
            colors: [Color.fromARGB(255, 108, 34, 123)],
            borderRadius: BorderRadius.circular(0),
            width: Responsive.isDesktop(context) ? 40 : 10,
            backDrawRodData: BackgroundBarChartRodData(
              y: 51,
              show: true,
              colors: [Color.fromRGBO(24, 231, 231, 1)],
            ),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barChartGroups,
      ),
    );
  } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

  