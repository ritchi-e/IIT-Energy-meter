import 'package:flutter/material.dart';
import 'package:flutter_responsive_dashboard_ui/dashboard.dart';
import 'package:flutter_responsive_dashboard_ui/influx_service.dart';
import 'package:flutter_responsive_dashboard_ui/style/colors.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_responsive_dashboard_ui/data_model.dart' as data;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:influxdb_client/api.dart' show FluxRecord;


late FirebaseDatabase database;
late DatabaseReference databaseReference;

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverride();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  database = FirebaseDatabase.instance;
  databaseReference = FirebaseDatabase.instance.ref().child('region');
  final InfluxService influxService = InfluxService();

  
 // List<MyDataModel> parsedData = await loadCSVData();
  List<data.MyDataModel> influxData = await influxService.getInfluxData("10m", "722748/0");

  runApp(MyApp(influxData: influxData));
 
}



/* Future<List<MyDataModel>>loadCSVData() async {
  final csvData = await rootBundle.loadString('csv_data/8822980_2023-06-22_11_13_influxdb_data.csv');

  // Parse the CSV data
  final List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

  // Process the CSV data
  List<MyDataModel> myDataList = []; // Create an empty list to store the data

  for (int i = 4; i < rows.length; i++) {
    final List<dynamic> row = rows[i];
  try{ 
      final String result = row.length > 1 ? row[1] as String : '';
      final int table = row.length > 2 ? int.tryParse(row[2].toString()) ?? 0 : 0;
      final DateTime start = row.length > 3 ? DateTime.parse(row[3]) : DateTime.now();
      final DateTime stop = row.length > 4 ? DateTime.parse(row[4]) : DateTime.now();
      final DateTime time = row.length > 5 ? DateTime.parse(row[5]) : DateTime.now();
      final double value = row.length > 6 ? double.tryParse(row[6].toString()) ?? 0.0 : 0.0;
      final String field = row.length > 7 ? row[7] as String : '';
      final String measurement = row.length > 8 ? row[8] as String : '';
      final String host = row.length > 9 ? row[9] as String : '';
      final String topic = row.length > 10 ? row[10] as String : '';

    final rowData = MyDataModel(
      result:result,
      table: table,
      start: start,
      stop: stop,
      time: time,
      value: value,
      field: field,
      measurement: measurement,
      host: host,
      topic: topic,
      column: field,
    );
    myDataList.add(rowData);
  } 
    catch (e) {
      print('Error in row $i: Error parsing column ${row.indexWhere((element) => element == e.toString())}');
      print('Error message: $e');
    }
  }
  // Perform any further actions with the parsed and processed CSV data
  for (final data in myDataList) {
  // print('Result: ${data.result}');
  // print('Table: ${data.table}');
  // print('Start: ${data.start}');
  // print('Stop: ${data.stop}');
  // print('Time: ${data.time}');
  // print('Value: ${data.value}');
  // print('Field: ${data.field}');
  // print('Measurement: ${data.measurement}');
  // print('Host: ${data.host}');
  // print('Topic: ${data.topic}');
}

  return myDataList;

} */





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final List<data.MyDataModel> influxData;
  const MyApp({Key? key, required this.influxData}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.primaryBg
      ),
      home: Dashboard(parsedData:influxData),
    );
  }
}

