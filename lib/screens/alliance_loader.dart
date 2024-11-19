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
  List<Alliance> searchResults = [];
  List<Alliance> alliances = [];
  bool showPerPersonPower = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.alliances == null) {
      _loadDefaultAlliances().then((loadedAlliances) {
        setState(() {
          alliances = loadedAlliances;
          _initializeSearchResults();
          _sortAlliances();
        });
      });
    } else {
      alliances = [...widget.alliances!];
      _initializeSearchResults();
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

  void _initializeSearchResults() {
    searchResults = [...alliances];
    _sortSearchResults();
  }

  void _sortAlliances() {
    alliances.sort((a, b) => _getSortablePower(b).compareTo(_getSortablePower(a)));
    _sortSearchResults();
  }

  void _sortSearchResults() {
    searchResults.sort((a, b) => _getSortablePower(b).compareTo(_getSortablePower(a)));
  }

  double _getSortablePower(Alliance alliance) {
    return showPerPersonPower
        ? (alliance.memberCount > 0
            ? alliance.power / alliance.memberCount
            : 0)
        : alliance.power.toDouble();
  }

  void _searchByAllianceName(String query) {
    final results = alliances
        .where((alliance) =>
            alliance.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    results.sort((a, b) => _getSortablePower(b).compareTo(_getSortablePower(a)));

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alliance Loader'),
      ),
      body: Row(
        children: [
          // 左側: 全ランキング
          Expanded(
            flex: 2,
            child: Column(
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
          ),

          // 右側: 同盟検索
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Alliance Name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _searchByAllianceName,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: AllianceTable(
                      data: searchResults,
                      showPerPersonPower: showPerPersonPower,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
