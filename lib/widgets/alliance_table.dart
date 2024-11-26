import 'package:flutter/material.dart';
import '../models/alliance.dart';

class AllianceTable extends StatelessWidget {
  final List<Alliance> data;
  final bool showPerPersonPower;

  const AllianceTable({
    Key? key,
    required this.data,
    required this.showPerPersonPower,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 上位50の同盟を抽出
    final limitedData = data.length > 50 ? data.sublist(0, 50) : data;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alliance Rankings'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('Rank')),
              DataColumn(label: Text('Server')),
              DataColumn(label: Text('Alliance')),
              DataColumn(
                  label: Text(showPerPersonPower ? 'Power Per Member' : 'Total Power')),
              DataColumn(label: Text('Members')),
            ],
            rows: limitedData.asMap().entries.map((entry) {
              final index = entry.key;
              final alliance = entry.value;
              final displayPower = showPerPersonPower
                  ? (alliance.memberCount > 0
                      ? (alliance.power / alliance.memberCount).toStringAsFixed(2)
                      : 'N/A')
                  : alliance.power.toString();

              return DataRow(cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 60), // 最小幅を指定
                    child: Text(
                      alliance.serverName,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis, // 溢れた部分を省略
                      softWrap: false, // 改行を防止
                    ),
                  ),
                ),
                DataCell(
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      alliance.name,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
                DataCell(Text(displayPower)),
                DataCell(Text(alliance.memberCount.toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
