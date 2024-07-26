class Ranker {
  final int id;
  final String username;
  final int point;

  Ranker({required this.id, required this.username, required this.point});

  factory Ranker.fromJson(Map<String, dynamic> json) {
    return Ranker(
      id: json['id'],
      username: json['username'],
      point: json['point'],
    );
  }
}

class Ranking {
  final List<Ranker> rankers;
  final bool result;
  final String timestamp;
  final String message;
  final String code;

  Ranking({
    required this.rankers,
    required this.result,
    required this.timestamp,
    required this.message,
    required this.code,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    var rankersJson = json['ranking']['rankers'] as List;
    List<Ranker> rankerList =
        rankersJson.map((rankerJson) => Ranker.fromJson(rankerJson)).toList();

    return Ranking(
      rankers: rankerList,
      result: json['result'],
      timestamp: json['timestamp'],
      message: json['message'],
      code: json['code'],
    );
  }
}
