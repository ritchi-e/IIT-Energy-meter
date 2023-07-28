// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_responsive_dashboard_ui/config/responsive.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';
import 'package:flutter_responsive_dashboard_ui/data_model.dart';
import '../main.dart';
import 'package:intl/intl.dart';



class BarChartCopmponent extends StatelessWidget {
  final List<MyDataModel> data; // Add this line to receive the data

  const BarChartCopmponent({
    required Key key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
       // Prepare the data for the bar chart
       
         List<BarChartGroupData> barChartGroups = data
             .map((data) {
          return BarChartGroupData(
           x: data.time.millisecondsSinceEpoch.toDouble().toInt(),
           barRods: [
           BarChartRodData(
            y: data.freq,
            colors: [Color.fromARGB(255, 108, 34, 123)],
            borderRadius: BorderRadius.circular(0),
            width: Responsive.isDesktop(context) ? 40 : 10,
            backDrawRodData: BackgroundBarChartRodData(
              y: 57,
              show: true,
              colors: [Color.fromRGBO(255, 185, 6, 1)],
            ),
          ),
        ],
      );
    }).toList();

    return BarChart(
     BarChartData(
        barGroups: barChartGroups,
        groupsSpace: 20, 
      titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: const Color.fromARGB(255, 132, 131, 131),
              fontWeight: FontWeight.bold,
            ),
            rotateAngle: 0,
            margin: 10,
            getTitles: (value) {
              // Convert the x-axis timestamp to a readable date format
              final DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              final DateFormat formatter = DateFormat('HH:mm:ss');
              return formatter.format(dateTime);
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          verticalInterval: 3, // Set the interval between vertical grid lines
        ),  
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: const Color.fromARGB(255, 229, 231, 233),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.toStringAsFixed(2),
                TextStyle(color: Color.fromARGB(255, 33, 20, 102)),
              );
            },
          ),
          ),
          axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(
            showTitle: true,
            titleText: 'Frequency', // Add a title for the y-axis
            textStyle: TextStyle(
              color: AppColors.iconGray,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.black, // Adjust border color as needed
            width: 1,
     ),
     ),
     ),
     );
   }
}

  