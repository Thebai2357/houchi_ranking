import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ServerListPage extends StatefulWidget {
  @override
  _ServerListPageState createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {
  List<List<String>> _servers = []; // サーバーデータを格納するリスト
  List<List<String>> _filteredServers = []; // フィルタリング後のリスト
  String _searchByName = ""; // サーバ名の検索キーワード
  String _searchByNumber = ""; // サーバ番号の検索キーワード

  // フォントサイズを統一管理
  final double headerFontSize = 40.0;
  final double bodyFontSize = 30.0;

  @override
  void initState() {
    super.initState();
    _loadServerData();
  }

  Future<void> _loadServerData() async {
    try {
      final csvData = await rootBundle.loadString('assets/servers.csv');
      List<List<String>> csvList =
          const LineSplitter().convert(csvData).map((line) {
        return line.split(',');
      }).toList();
      setState(() {
        _servers = csvList;
        _filteredServers = csvList; // 初期状態では全データを表示
      });
    } catch (e) {
      print('Error loading CSV file: $e');
    }
  }

  void _filterServers() {
    setState(() {
      _filteredServers = _servers.where((server) {
        final serverNumber = server[0];
        final serverName = server[1].toLowerCase();
        final matchesName =
            serverName.contains(_searchByName.toLowerCase());
        final matchesNumber = serverNumber == _searchByNumber || _searchByNumber.isEmpty;
        return matchesName && matchesNumber;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サーバー一覧'),
      ),
      body: Row(
        children: [
          // サーバリストの表形式表示
          Expanded(
            flex: 1,
            child: _filteredServers.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(
                            label: Text('番号',
                                style: TextStyle(fontSize: headerFontSize))), // 列ヘッダーの文字サイズ
                        DataColumn(
                            label: Text('サーバー名',
                                style: TextStyle(fontSize: headerFontSize))),
                      ],
                      rows: _filteredServers.map((server) {
                        return DataRow(cells: [
                          DataCell(Text(server[0],
                              style: TextStyle(fontSize: bodyFontSize))), // 行データの文字サイズ
                          DataCell(Text(server[1],
                              style: TextStyle(fontSize: bodyFontSize))),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
          // 検索窓
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('サーバ名で検索',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: headerFontSize)),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchByName = value;
                        _filterServers();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '例: Alpha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('サーバ番号で検索',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: headerFontSize)),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchByNumber = value;
                        _filterServers();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '例: 1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _searchByName = "";
                        _searchByNumber = "";
                        _filteredServers = _servers;
                      });
                    },
                    child: Text('リセット', style: TextStyle(fontSize: bodyFontSize)),
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