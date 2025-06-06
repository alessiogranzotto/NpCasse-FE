import 'package:intl/intl.dart';

class MyosotisAccessModel {
  MyosotisAccessModel({
    required this.idLog,
    required this.area,
    required this.method,
    required this.logType,
    required this.shortMessage,
    required this.fullMessage,
    required this.dateIns,
  });

  late final int idLog;
  late final String area;
  late final String method;
  late final String logType;
  late final String shortMessage;
  late final String fullMessage;
  late final DateTime dateIns;

  // Empty constructor with default values
  MyosotisAccessModel.empty()
      : idLog = 0,
        area = '',
        method = '',
        logType = '',
        shortMessage = '',
        fullMessage = '',
        dateIns = DateTime.now();

  // JSON deserialization
  MyosotisAccessModel.fromJson(Map<String, dynamic> json) {
    idLog = json['idLog'];
    area = json['area'];
    method = json['method'];
    logType = json['logType'];
    shortMessage = json['shortMessage'];
    fullMessage = json['fullMessage'] ?? '';

    final parsedDate =
        DateTime.tryParse(json['dateIns'] ?? '') ?? DateTime.now();
    dateIns = parsedDate.toLocal();
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'idLog': idLog,
      'area': area,
      'method': method,
      'logType': logType,
      'shortMessage': shortMessage,
      'fullMessage': fullMessage,
      'dateIns': dateIns.toIso8601String(),
    };
  }
}
