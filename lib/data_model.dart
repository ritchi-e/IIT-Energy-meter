class MyDataModel{
  final String result;
  final int table;
  final DateTime start;
  final DateTime stop;
  final DateTime time;
  final double value;
 
  final String measurement;
  final String host;
  final String topic;
  final double avgPF;
  final double freq;
  final double i1;
  final double i2;
  final double i3;
  final double pf1;
  final double pf2;
  final double pf3;
  final double tkVA;
  final double tkVAr;
  final double tkW;
  final double v1N;
  final double v2N;
  final double v3N;
  final double kW1;
  final double kW2;
  final double kW3;
  final double kWh;

  MyDataModel({
    required this.result,
    required this.table,
    required this.start,
    required this.stop,
    required this.time,
    required this.value,
   
    required this.measurement,
    required this.host,
    required this.topic,
    required this.avgPF,
    required this.freq,
    required this.i1,
    required this.i2,
    required this.i3,
    required this.pf1,
    required this.pf2,
    required this.pf3,
    required this.tkVA,
    required this.tkVAr,
    required this.tkW,
    required this.v1N,
    required this.v2N,
    required this.v3N,
    required this.kW1,
    required this.kW2,
    required this.kW3,
    required this.kWh,
  });
  

  // Add a factory method to convert the JSON data to MyDataModel object
  factory MyDataModel.fromJson(Map<String, dynamic> json) {
    return MyDataModel(
      result: json['result'] ?? '',
      table: json['table'] ?? 0,
      start: json['_start'] != null ? DateTime.parse(json['_start']) : DateTime.now(),
      stop: json['_stop'] != null ? DateTime.parse(json['_stop']) : DateTime.now(),
      time: json['_time'] != null ? DateTime.parse(json['_time']) : DateTime.now(),
      value: json['_value'] != null ? double.tryParse(json['_value'].toString()) ?? 0.0 : 0.0,
      
      measurement: json['_measurement'] ?? '',
      host: json['host'] ?? '',
      topic: json['topic'] ?? '',
      avgPF: json['AvgPF'] ?? 0.0,
      freq: json['Freq'] ?? 0.0,
      i1: json['I1'] ?? 0.0,
      i2: json['I2'] ?? 0.0,
      i3: json['I3'] ?? 0.0,
      pf1: json['PF1'] ?? 0.0,
      pf2: json['PF2'] ?? 0.0,
      pf3: json['PF3'] ?? 0.0,
      tkVA: json['TkVA'] ?? 0.0,
      tkVAr: json['TkVAr'] ?? 0.0,
      tkW: json['TkW'] ?? 0.0,
      v1N: json['V1N'] ?? 0.0,
      v2N: json['V2N'] ?? 0.0,
      v3N: json['V3N'] ?? 0.0,
      kW1: json['kW1'] ?? 0.0,
      kW2: json['kW2'] ?? 0.0,
      kW3: json['kW3'] ?? 0.0,
      kWh: json['kWh'] ?? 0.0,
    );
  }
  
}

