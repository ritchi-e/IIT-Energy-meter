import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_model.dart';

enum ChartType { current, voltage }



class LineChartComponent extends StatelessWidget {
  String formatTimestamp(double value) {
    int milliseconds = value.toInt();
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    int remainingMilliseconds = milliseconds % 1000;
    int remainingSeconds = seconds % 60;
    int remainingMinutes = minutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}.${remainingMilliseconds.toString().padLeft(3, '0')}';
  }
  final List<MyDataModel> dataList;
  final ChartType chartType;

  LineChartComponent({required this.dataList, required this.chartType});

  @override
  Widget build(BuildContext context) {
    dataList.sort((a, b) => a.time.compareTo(b.time));
   List<int> indexList = List.generate(dataList.length, (index) => index);

   List<FlSpot> i1Spots = indexList.map((index) => FlSpot(index.toDouble(), dataList[index].i1)).toList();
    List<FlSpot> i2Spots = indexList.map((index) => FlSpot(index.toDouble(), dataList[index].i2)).toList();
    List<FlSpot> i3Spots = indexList.map((index) => FlSpot(index.toDouble(), dataList[index].i3)).toList();
    List<FlSpot> v1nSpots = indexList.map((index) => FlSpot(index.toDouble(), dataList[index].v1N)).toList();
    List<FlSpot> v2nSpots = indexList.map((index) => FlSpot(index.toDouble(), dataList[index].v2N)).toList();
    List<FlSpot> v3nSpots = indexList.map((index) => FlSpot(index.toDouble(), dataList[index].v3N)).toList();

 List<double> allVoltages = [
    ...dataList.map((data) => data.v1N),
    ...dataList.map((data) => data.v2N),
    ...dataList.map((data) => data.v3N),
  ];

  double minVoltage = allVoltages.reduce((value, element) => value < element ? value : element);
  double maxVoltage = allVoltages.reduce((value, element) => value > element ? value : element);

    List<Color> currentColors = [
      Color.fromRGBO(6, 59, 193, 1), // Color for I1 line
      Color.fromRGBO(58, 245, 64, 1), // Color for I2 line
      Color.fromRGBO(237, 14, 14, 1), // Color for I3 line
    ];

    List<Color> voltageColors = [
      Color.fromRGBO(255, 149, 0, 1), // Color for V1N line
      Color.fromRGBO(72, 254, 36, 1), // Color for V2N line
      Color.fromRGBO(199, 14, 196, 1), // Color for V3N line
    ];

    List<LineChartBarData> currentLines = [
      LineChartBarData(
        spots: i1Spots,
        isCurved: true,
        barWidth: 2,
        colors: [currentColors[0]],
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
       
      
      ),
      LineChartBarData(
        spots: i2Spots,
        isCurved: true,
        barWidth: 2,
        colors: [currentColors[1]],
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
       
   
      ),
      LineChartBarData(
        spots: i3Spots,
        isCurved: true,
        barWidth: 2,
        colors: [currentColors[2]],
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
       
   
      ),
    ];

    List<LineChartBarData> voltageLines = [
      LineChartBarData(
        spots: v1nSpots,
        isCurved: false,
        barWidth: 2,
        colors: [voltageColors[0]],
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
       
   
      ),
      LineChartBarData(
        spots: v2nSpots,
        isCurved: false,
        barWidth: 2,
        colors: [voltageColors[1]],
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      
   
      ),
      LineChartBarData(
        spots: v3nSpots,
        isCurved: false,
        barWidth: 2,
        colors: [voltageColors[2]],
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
       
   
    ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        if (chartType == ChartType.current) ...[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: 400,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: dataList.length.toDouble() - 1,
                  minY: -1,
                  maxY: 1,
                  borderData: FlBorderData(
    show: true,
    border: Border.all(color: const Color.fromARGB(255, 220, 222, 224), width: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                        color: Color.fromARGB(255, 123, 160, 163),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      getTitles: (value) {
                      return formatIndexAsText(value.toInt());
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                        color: Color.fromARGB(255, 126, 184, 198),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  lineBarsData: currentLines,
                ),
              ),
            ),
          ),
           Expanded(
            child: SizedBox(
                width: double.infinity,
                height: 40, // Adjust the height as needed for the legend
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < currentLines.length; i++)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: currentLines[i].colors[0],
                            ),
                            SizedBox(width: 4),
                            Text('I${i + 1}',
                            style: TextStyle(
                         color: const Color.fromARGB(255, 237, 239, 241),),
                         ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
           ),
            ],
      
      
          
        
      
        SizedBox(height: 20),
        if (chartType == ChartType.voltage) ...[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: 400,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: dataList.length.toDouble() - 1,
                minY: minVoltage,
                maxY: maxVoltage,
                borderData: FlBorderData(
    show: true,
    border: Border.all(color: Colors.blue, width: 1),
                ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                        color: Color.fromARGB(255, 112, 201, 198),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      getTitles: (value) {
                       return formatIndexAsText(value.toInt());
                    
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                        color: Color.fromARGB(255, 115, 196, 210),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  lineBarsData: voltageLines,
                ),
              ),
            ),
          ),
            Expanded(
              child:SizedBox(
                width: double.infinity,
                height: 40, // Adjust the height as needed for the legend
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < voltageLines.length; i++)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: voltageLines[i].colors[0],
                            ),
                            SizedBox(width: 4),
                            Text('V${i + 1}N',
                            style: TextStyle(
                         color: const Color.fromARGB(255, 237, 239, 241),),
                            ),  
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        SizedBox(height: 20),
      ],
    );
  }
   String formatIndexAsText(int index) {
    return index.toString();
  }

  // Helper method to format the timestamp with milliseconds
 
}

