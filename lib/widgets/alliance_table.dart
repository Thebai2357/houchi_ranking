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
            DataColumn(label: Text('Server Name')),
            DataColumn(label: Text('Alliance Name')),
            DataColumn(label: Text('Members')),
            DataColumn(
                label: Text(showPerPersonPower ? 'Power Per Member' : 'Total Power')),
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
              DataCell(Text(alliance.name)),
              DataCell(Text(alliance.memberCount.toString())),
              DataCell(Text(displayPower)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
