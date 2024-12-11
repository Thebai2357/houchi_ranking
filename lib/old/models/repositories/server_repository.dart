import 'package:flutter/services.dart' show rootBundle;
import '../models/server.dart';
import 'package:csv/csv.dart';

class ServerRepository {
  static Future<List<Server>> loadDefaultServers() async {
    final csvContent = await rootBundle.loadString('assets/servers.csv');
    final rows = const CsvToListConverter().convert(csvContent);
    return rows
        .map((row) => Server.fromCsv(row.map((e) => e.toString()).toList()))
        .toList();
  }
}