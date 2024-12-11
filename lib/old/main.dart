import 'package:flutter/material.dart';
import 'screens/alliance_loader.dart';
import 'screens/server_table_screen.dart';
import 'repositories/server_repository.dart';
import 'models/server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final servers = await ServerRepository.loadDefaultServers();

  runApp(MyApp(servers: servers));
}

class MyApp extends StatelessWidget {
  final List<Server> servers;

  MyApp({required this.servers});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server and Alliance Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(servers: servers),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Server> servers;

  HomeScreen({required this.servers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Server and Alliance Manager')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
        children: [
          // サーバデータ表示ボタン
          SizedBox(
            width: 300, // ボタンの幅
            height: 80, // ボタンの高さ
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServerTableScreen(servers: servers),
                ),
              ),
              child: Text(
                'View Server Data (Table)',
                style: TextStyle(fontSize: 20), // テキストサイズ
              ),
            ),
          ),
          const SizedBox(height: 20), // ボタン間のスペース

          // 同盟データ読み込みボタン
          SizedBox(
            width: 300,
            height: 80,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllianceLoader()),
              ),
              child: Text(
                'Load Alliance Data',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
