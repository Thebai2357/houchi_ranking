import 'package:flutter/material.dart';

class AllianceRankingPage extends StatefulWidget {
  final List<Map<String, dynamic>> alliances; // データを受け取るプロパティ

  AllianceRankingPage({required this.alliances}); // 必須パラメータとしてコンストラクタを追加

  @override
  _AllianceRankingPageState createState() => _AllianceRankingPageState();
}

class _AllianceRankingPageState extends State<AllianceRankingPage> {
  String _searchQuery = ''; // 検索クエリ
  List<Map<String, dynamic>> _searchResults = []; // 検索結果

  @override
  void initState() {
    super.initState();
    _searchResults = widget.alliances; // 初期状態ではすべてのデータを表示
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _searchResults = widget.alliances.where((alliance) {
        return alliance['serverName'].toLowerCase().contains(_searchQuery) ||
            alliance['allianceName'].toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('同盟ランキング'),
      ),
      body: Row(
        children: [
          // 左半分: ランキングリスト
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('順位')),
                    DataColumn(label: Text('サーバー名')),
                    DataColumn(label: Text('同盟名')),
                    DataColumn(label: Text('人数')),
                    DataColumn(label: Text('勢力値')),
                  ],
                  rows: widget.alliances.asMap().entries.map((entry) {
                    final index = entry.key;
                    final alliance = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')), // 順位
                        DataCell(Text(alliance['serverName'])),
                        DataCell(Text(alliance['allianceName'])),
                        DataCell(Text('${alliance['memberCount']}')),
                        DataCell(Text('${alliance['power']}')),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // 右半分: 検索窓と結果
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (value) => _performSearch(value),
                    decoration: InputDecoration(
                      hintText: 'サーバー名または同盟名で検索',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('順位')),
                        DataColumn(label: Text('同盟名')),
                        DataColumn(label: Text('勢力値')),
                      ],
                      rows: _searchResults.map((alliance) {
                        final index = widget.alliances.indexOf(alliance); // 左側のランキングから順位を取得
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')), // 左側のランキングの順位
                            DataCell(Text(alliance['allianceName'])),
                            DataCell(Text('${alliance['power']}')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}