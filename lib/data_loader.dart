import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

// データをロードして降順ソートし、上位100データのみを取得する関数
Future<List<Map<String, dynamic>>> loadAllianceData() async {
  final csvData = await rootBundle.loadString('assets/alliances.csv');
  List<List<String>> csvList = const LineSplitter().convert(csvData).map((line) {
    return line.split(',');
  }).toList();

  // データをマップ形式に変換
  List<Map<String, dynamic>> alliances = csvList.map((row) {
    return {
      'serverName': row[0],
      'allianceName': row[1],
      'memberCount': int.tryParse(row[2]) ?? 0,
      'power': int.tryParse(row[3]) ?? 0,
    };
  }).toList();

  // 降順ソートして上位100データを取得
  alliances.sort((a, b) => b['power'].compareTo(a['power']));
  return alliances.take(100).toList(); // 上位100件を返す
}