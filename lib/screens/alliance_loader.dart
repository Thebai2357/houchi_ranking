import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/alliance.dart';
import 'package:csv/csv.dart';
import '../widgets/alliance_table.dart';

class AllianceLoader extends StatefulWidget {
  final List<Alliance>? alliances;

  AllianceLoader({this.alliances});

  @override
  _AllianceLoaderState createState() => _AllianceLoaderState();
}

class _AllianceLoaderState extends State<AllianceLoader> {
  List<Alliance> alliances = [];
  bool showPerPersonPower = false;

  @override
  void initState() {
    super.initState();
    if (widget.alliances == null) {
      _loadDefaultAlliances().then((loadedAlliances) {
        setState(() {
          alliances = loadedAlliances;
          _sortAlliances();
        });
      });
    } else {
      alliances = [...widget.alliances!];
      _sortAlliances();
    }
  }

  Future<List<Alliance>> _loadDefaultAlliances() async {
    try {
      // CSVファイルを読み込む
      final csvContent = await rootBundle.loadString('assets/alliances.csv');

      // CSVデータをパース
      final rows = const CsvToListConverter().convert(csvContent);

      // 各行をAllianceオブジェクトに変換
      return rows
          .map((row) => Alliance.fromCsv(row.map((e) => e.toString()).toList()))
          .toList();
    } catch (e) {
      // エラーが発生した場合、空のリストを返す
      print('Error loading alliances: $e');
      return [];
    }
  }

  void _sortAlliances() {
    alliances.sort((a, b) => _getSortablePower(b).compareTo(_getSortablePower(a)));
  }

  double _getSortablePower(Alliance alliance) {
    return showPerPersonPower
        ? (alliance.memberCount > 0
            ? alliance.power / alliance.memberCount
            : 0)
        : alliance.power.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alliance Loader'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                showPerPersonPower = !showPerPersonPower;
                _sortAlliances();
              });
            },
            child: Text(showPerPersonPower
                ? 'Show Total Power'
                : 'Show Power Per Member'),
          ),
          Expanded(
            child: AllianceTable(
              data: alliances,
              showPerPersonPower: showPerPersonPower,
            ),
          ),
        ],
      ),
    );
  }
}
