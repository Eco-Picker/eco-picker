class Ranker {
  final int id;
  final String username;
  final int point;
  final int rank;

  Ranker(
      {required this.id,
      required this.username,
      required this.point,
      this.rank = 0});

  factory Ranker.fromJson(Map<String, dynamic> json) {
    return Ranker(
      id: json['id'],
      username: json['username'],
      point: json['point'],
    );
  }

  Ranker copyWith({
    String? username,
    int? point,
    int? id,
    int? rank,
  }) {
    return Ranker(
      username: username ?? this.username,
      point: point ?? this.point,
      id: id ?? this.id,
      rank: rank ?? this.rank,
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
    var rankersJson = json['rankers'] as List<dynamic>? ?? [];
    List<Ranker> rankerList =
        rankersJson.map((rankerJson) => Ranker.fromJson(rankerJson)).toList();

    return Ranking(
      rankers: rankerList,
      result: json['result'] ?? false,
      timestamp: json['timestamp'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
