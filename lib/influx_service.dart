import 'dart:convert';
import 'package:flutter_responsive_dashboard_ui/data_model.dart' as data;
import 'package:influxdb_client/api.dart'show InfluxDBClient, FluxRecord, QueryService;

class InfluxService {
  late InfluxDBClient client;
  late QueryService queryService;
  InfluxService() {
    client = InfluxDBClient(
        url: 'http://10.17.51.12:8086',
        token:
            'gD5kuHNGXz9MGzeRlJ7MGT0wPa7bNlLQ8eS8giLyqx1wXURon3ZWQ1DfyTdJ8asm1WDvgiEYgjvvhH2sZDD9pw==',
        org: 'IIT-Delhi',
        bucket: 'iitdenergy',
        debug: true);
    queryService = client.getQueryService();
  }

  Future<List<data.MyDataModel>>getInfluxData(String time, String sensorId) async {
    String query = '''
from(bucket: "iitdenergy")
    |> range(start: -$time)
    |> filter(fn: (r) => r["_measurement"] == "mqtt_consumer")
    |> filter(fn: (r) => r["_field"] == "AvgPF" or r["_field"] == "Freq" or r["_field"] == "I1" or r["_field"] == "I2" or r["_field"] == "I3" or r["_field"] == "PF1" or r["_field"] == "PF2" or r["_field"] == "PF3" or r["_field"] == "TkVA" or r["_field"] == "TkVAr" or r["_field"] == "TkW" or r["_field"] == "V1N" or r["_field"] == "V2N" or r["_field"] == "V3N" or r["_field"] == "kW1" or r["_field"] == "kW2" or r["_field"] == "kW3" or r["_field"] == "kWh")
    |> filter(fn: (r) => r["topic"] == "/devices/swsn/FSM-$sensorId")
    |> filter(fn: (r) => r["host"] == "baadalvm")
    |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
    |> yield(name: "results")
''';
    var recordStream = await queryService.query(query);
    var recordList = await recordStream.toList();
    print(jsonEncode(recordList));
    List<data.MyDataModel> myDataList = recordList.map((record) => _convertRecordToMap(record) as data.MyDataModel).toList().cast<data.MyDataModel>();
    return myDataList;
  }

  data.MyDataModel _convertRecordToMap(FluxRecord record) {
    

    final String? result = record['_field'];
    final DateTime? time = record['time'] != null ? DateTime.parse(record['time']) : null;
    final double? value = record['_value']!= null ? double.tryParse(record['_value'].toString()) : null;
    final String? measurement = record['_measurement'];

    return data.MyDataModel(
      result: result ?? '',
      table: 0, 
      start:time ?? DateTime.now(),
      stop:time ?? DateTime.now(),
      time:time ?? DateTime.now(),
      value: value ?? 0.0,
    
      measurement:measurement ?? '',
      host: '',
      topic: '',
      avgPF: record['AvgPF'] ?? 0.0,
      freq: record['Freq'] ?? 0.0,
      i1: record['I1'] ?? 0.0,
      i2: record['I2'] ?? 0.0,
      i3: record['I3'] ?? 0.0,
      pf1: record['PF1'] ?? 0.0,
      pf2: record['PF2'] ?? 0.0,
      pf3: record['PF3'] ?? 0.0,
      tkVA: record['TkVA'] ?? 0.0,
      tkVAr: record['TkVAr'] ?? 0.0,
      tkW: record['TkW'] ?? 0.0,
      v1N: record['V1N'] ?? 0.0,
      v2N: record['V2N'] ?? 0.0,
      v3N: record['V3N'] ?? 0.0,
      kW1: record['kW1'] ?? 0.0,
      kW2: record['kW2'] ?? 0.0,
      kW3: record['kW3'] ?? 0.0,
      kWh: record['kWh'] ?? 0.0,
    );


}
}