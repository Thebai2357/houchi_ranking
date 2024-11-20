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
    return SingleChildScrollView(
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
            DataColumn(label: Text('Members')), // MembersをPowerの後に移動
          ],
          rows: data.asMap().entries.map((entry) {
            final index = entry.key;
            final alliance = entry.value;
            final displayPower = showPerPersonPower
                ? (alliance.memberCount > 0
                    ? (alliance.power / alliance.memberCount).toStringAsFixed(2)
                    : 'N/A')
                : alliance.power.toString();

            return DataRow(cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text(alliance.serverName)),
              DataCell(
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100), // セルの最大幅を設定
                  child: Text(
                    alliance.name,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
              ),
              DataCell(Text(displayPower)), // Powerを先に表示
              DataCell(Text(alliance.memberCount.toString())), // Membersを後に表示
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
