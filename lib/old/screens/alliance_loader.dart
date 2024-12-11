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
  List<Map<String, dynamic>> searchResults = []; // 検索結果は順位とデータのペア
  bool showPerPersonPower = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? highlightedIndex; // ハイライトする行のインデックス

  @override
  void initState() {
    super.initState();
    if (widget.alliances == null) {
      _loadDefaultAlliances().then((loadedAlliances) {
        setState(() {
          alliances = loadedAlliances;
          _sortAlliances(); // 全体を勢力値でソート
          _initializeSearchResults(); // ランクを付ける
        });
      });
    } else {
      alliances = [...widget.alliances!];
      _sortAlliances();
      _initializeSearchResults();
    }
  }

  Future<List<Alliance>> _loadDefaultAlliances() async {
    try {
      final csvContent = await rootBundle.loadString('assets/alliances.csv');
      final rows = const CsvToListConverter().convert(csvContent);
      return rows
          .map((row) => Alliance.fromCsv(row.map((e) => e.toString()).toList()))
          .toList();
    } catch (e) {
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

  void _initializeSearchResults() {
    searchResults = alliances
        .asMap()
        .entries
        .map((entry) => {'rank': entry.key + 1, 'data': entry.value})
        .toList();
  }

  void _searchByAllianceName(String query) {
    setState(() {
      if (query.isEmpty) {
        _initializeSearchResults();
        highlightedIndex = null;
      } else {
        searchResults = alliances
            .asMap()
            .entries
            .where((entry) =>
                entry.value.name.toLowerCase().contains(query.toLowerCase()))
            .map((entry) => {'rank': entry.key + 1, 'data': entry.value})
            .toList();

        // ハイライトするインデックスを取得
        if (searchResults.isNotEmpty) {
          highlightedIndex = searchResults.first['rank'] - 1;

          // 該当位置にスクロール
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (highlightedIndex != null) {
              _scrollController.animateTo(
                highlightedIndex! * 56.0, // 行の高さ * インデックス
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });
        } else {
          highlightedIndex = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alliance Loader'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Alliance',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _searchByAllianceName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showPerPersonPower = !showPerPersonPower;
                      });
                    },
                    child: Text(showPerPersonPower
                        ? 'Show Total Power'
                        : 'Show Power Per Member'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: AllianceTable(
                data: searchResults,
                showPerPersonPower: showPerPersonPower,
                highlightedIndex: highlightedIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
