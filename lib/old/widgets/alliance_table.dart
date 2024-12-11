import 'package:flutter/material.dart';
import '../models/alliance.dart';

class AllianceTable extends StatelessWidget {
  final List<Map<String, dynamic>> data; // ランク情報を含むリスト
  final bool showPerPersonPower;
  final int? highlightedIndex;

  const AllianceTable({
    Key? key,
    required this.data,
    required this.showPerPersonPower,
    this.highlightedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
        rows: data.asMap().entries.map((entry) {
          final index = entry.key;
          final rank = entry.value['rank'];
          final alliance = entry.value['data'];
          final displayPower = showPerPersonPower
              ? (alliance.memberCount > 0
                  ? (alliance.power / alliance.memberCount).toStringAsFixed(2)
                  : 'N/A')
              : alliance.power.toString();

          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (index == highlightedIndex) {
                  return Colors.yellow.withOpacity(0.3);
                }
                return null;
              },
            ),
            cells: [
              DataCell(Text('$rank')), // 全体のランクを表示
              DataCell(Text(alliance.serverName)),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
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
            ],
          );
        }).toList(),
      ),
    );
  }
}
