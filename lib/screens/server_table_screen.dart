import 'package:flutter/material.dart';
import '../models/server.dart';

class ServerTableScreen extends StatefulWidget {
  final List<Server> servers;

  ServerTableScreen({required this.servers});

  @override
  _ServerTableScreenState createState() => _ServerTableScreenState();
}

class _ServerTableScreenState extends State<ServerTableScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  String _nameResult = "";
  String _numberResult = "";

  void _searchByName(String name) {
    final server = widget.servers.firstWhere(
      (server) => server.name.toLowerCase() == name.toLowerCase(),
      orElse: () => Server(number: -1, name: "Not Found"),
    );
    setState(() {
      _numberResult = server.number != -1 ? server.number.toString() : "Not Found";
    });
  }

  void _searchByNumber(String number) {
    final server = widget.servers.firstWhere(
      (server) => server.number.toString() == number,
      orElse: () => Server(number: -1, name: "Not Found"),
    );
    setState(() {
      _nameResult = server.name != "Not Found" ? server.name : "Not Found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Data'),
      ),
      body: Row(
        children: [
          // 左側: サーバリスト
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Server Number')),
                    DataColumn(label: Text('Server Name')),
                  ],
                  rows: widget.servers.map((server) {
                    return DataRow(cells: [
                      DataCell(Text(server.number.toString())),
                      DataCell(Text(server.name)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),

          // 右側: 検索フィールドと結果表示
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // サーバ名から番号を検索
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'サーバ名を入力してください',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _searchByName(value),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'サーバ番号: $_numberResult',
                    style: const TextStyle(
                      fontSize: 20.0, // こちらも文字サイズを大きく変更
                    ),  
                  ),
                  const SizedBox(height: 16),

                  // サーバ番号から名前を検索
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'サーバ番号を入力してください',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _searchByNumber(value),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'サーバ名: $_nameResult',
                    style: const TextStyle(
                      fontSize: 20.0, // こちらも文字サイズを大きく変更
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
