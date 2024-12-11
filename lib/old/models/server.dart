class Server {
  final int number; // サーバー番号
  final String name; // サーバー名

  Server({
    required this.number,
    required this.name,
  });

  factory Server.fromCsv(List<String> csvRow) {
    return Server(
      number: int.parse(csvRow[0]),
      name: csvRow[1],
    );
  }
}