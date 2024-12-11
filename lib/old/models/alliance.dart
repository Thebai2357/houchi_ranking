class Alliance {
  final String serverName; // サーバー名
  final String name; // 同盟名
  final int memberCount; // 所属人数
  final int power; // 勢力値

  Alliance({
    required this.serverName,
    required this.name,
    required this.memberCount,
    required this.power,
  });

  factory Alliance.fromCsv(List<String> csvRow) {
    return Alliance(
      serverName: csvRow[0],
      name: csvRow[1],
      memberCount: int.parse(csvRow[2]),
      power: int.parse(csvRow[3]),
    );
  }
}
