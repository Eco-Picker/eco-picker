class User {
  final int id;
  final String username;
  final String email;
  final String onboardingStatus;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.onboardingStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      onboardingStatus: json['onboardingStatus'],
    );
  }
}

class UserStatistics {
  final Count count;
  final Score score;
  final String userName;

  UserStatistics({
    required this.count,
    required this.score,
    required this.userName,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    String userName;
    Count count;
    Score score;
    if (json.containsKey('rankerStatistics')) {
      userName = json['username'] ?? 'Unknown';
      count = Count.fromJson(json['rankerStatistics']['count'] ?? {});
      score = Score.fromJson(json['rankerStatistics']['score'] ?? {});
    } else {
      userName = json['username']['userName'] ?? 'Unknown';
      count = Count.fromJson(json['count'] ?? {});
      score = Score.fromJson(json['score'] ?? {});
    }

    return UserStatistics(
      count: count,
      score: score,
      userName: userName,
    );
  }

  String getRank() {
    final int totalScore = score.totalScore;

    if (totalScore >= 10001) {
      return 'Master';
    } else if (totalScore >= 7501) {
      return 'Diamond';
    } else if (totalScore >= 5001) {
      return 'Gold';
    } else if (totalScore >= 2501) {
      return 'Silver';
    } else if (totalScore >= 0) {
      return 'Bronze';
    } else {
      return 'Unknown'; // 점수가 0보다 작은 경우를 대비한 처리
    }
  }
}

class Count {
  final int totalCount;
  final int totalDailyCount;
  final int totalWeeklyCount;
  final int totalMonthlyCount;
  final int totalCardboardPaper;
  final int totalPlastic;
  final int totalGlass;
  final int totalOther;
  final int totalMetal;
  final int totalFoodScraps;
  final int totalOrganicYardWaste;

  Count({
    required this.totalCount,
    required this.totalDailyCount,
    required this.totalWeeklyCount,
    required this.totalMonthlyCount,
    required this.totalCardboardPaper,
    required this.totalPlastic,
    required this.totalGlass,
    required this.totalOther,
    required this.totalMetal,
    required this.totalFoodScraps,
    required this.totalOrganicYardWaste,
  });

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      totalCount: json['totalCount'] ?? 0,
      totalDailyCount: json['totalDailyCount'] ?? 0,
      totalWeeklyCount: json['totalWeeklyCount'] ?? 0,
      totalMonthlyCount: json['totalMonthlyCount'] ?? 0,
      totalCardboardPaper: json['totalCardboardPaper'] ?? 0,
      totalPlastic: json['totalPlastic'] ?? 0,
      totalGlass: json['totalGlass'] ?? 0,
      totalOther: json['totalOther'] ?? 0,
      totalMetal: json['totalMetal'] ?? 0,
      totalFoodScraps: json['totalFoodScraps'] ?? 0,
      totalOrganicYardWaste: json['totalOrganicYardWaste'] ?? 0,
    );
  }
}

class Score {
  final int totalScore;
  final int cardboardPaperScore;
  final int plasticScore;
  final int glassScore;
  final int otherScore;
  final int metalScore;
  final int foodScrapsScore;
  final int organicYardWasteScore;

  Score({
    required this.totalScore,
    required this.cardboardPaperScore,
    required this.plasticScore,
    required this.glassScore,
    required this.otherScore,
    required this.metalScore,
    required this.foodScrapsScore,
    required this.organicYardWasteScore,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      totalScore: json['totalScore'] ?? 0,
      cardboardPaperScore: json['cardboardPaperScore'] ?? 0,
      plasticScore: json['plasticScore'] ?? 0,
      glassScore: json['glassScore'] ?? 0,
      otherScore: json['otherScore'] ?? 0,
      metalScore: json['metalScore'] ?? 0,
      foodScrapsScore: json['foodScrapsScore'] ?? 0,
      organicYardWasteScore: json['organicYardWasteScore'] ?? 0,
    );
  }
}
