import 'package:flutter/material.dart';
import 'alliance_ranking_page.dart';
import 'server_list_page.dart';
import 'data_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final alliances = await loadAllianceData(); // データを事前にロード
  runApp(MyApp(alliances: alliances));
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> alliances;

  MyApp({required this.alliances});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '同盟ランキングアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(alliances: alliances), // データをホームページに渡す
    );
  }
}

// ホームページ（ボタンで各ページに遷移）
class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> alliances;

  HomePage({required this.alliances});

  // フォントサイズやスタイルを統一管理
  final double titleFontSize = 60.0;
  final double buttonFontSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム', style: TextStyle(fontSize: titleFontSize)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 同盟ランキングボタン
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllianceRankingPage(alliances: alliances),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0, 500), // ボタンの高さを設定
                    textStyle: TextStyle(fontSize: buttonFontSize),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 四角形に角丸を追加
                    ),
                  ),
                  child: Text('同盟ランキングページ'),
                ),
              ),
              SizedBox(width: 16), // ボタン間のスペース
              // サーバリストボタン
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServerListPage(), // サーバリストページに遷移
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0, 500), // ボタンの高さを設定
                    textStyle: TextStyle(fontSize: buttonFontSize),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 四角形に角丸を追加
                    ),
                  ),
                  child: Text('サーバリストページ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}