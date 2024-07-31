class Newsletter {
  final int id;
  final String title;
  final String content;
  final String category;
  final String source;
  final String? publishedAt;
  final String? startAt;
  final String? endAt;

  Newsletter({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.source,
    this.publishedAt,
    this.startAt,
    this.endAt,
  });

  factory Newsletter.fromJson(Map<String, dynamic> json) {
    return Newsletter(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      category: json["category"],
      source: json["source"],
      publishedAt: json["publishedAt"],
      startAt: json["startAt"],
      endAt: json["endAt"],
    );
  }
}

class NewsSummary {
  final int id;
  final String title;
  final String summary;
  final String category;

  NewsSummary({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
  });

  factory NewsSummary.fromJson(Map<String, dynamic> json) {
    return NewsSummary(
      id: json["id"],
      title: json["title"],
      summary: json["summary"],
      category: json["category"],
    );
  }
}

class NewsList {
  final List<NewsSummary> newsletterList;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool result;
  final String timestamp;
  final String? message;
  final String? code;

  NewsList({
    required this.newsletterList,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.result,
    required this.timestamp,
    required this.message,
    required this.code,
  });

  factory NewsList.fromJson(Map<String, dynamic> json) {
    var newsJson = json['newsletterSummaryList'] as List<dynamic>? ?? [];
    List<NewsSummary> newsList =
        newsJson.map((newsJson) => NewsSummary.fromJson(newsJson)).toList();

    return NewsList(
      newsletterList: newsList,
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      result: json['result'],
      timestamp: json['timestamp'],
      message: json['message'],
      code: json['code'],
    );
  }
}
