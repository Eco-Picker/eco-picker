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

  UserStatistics({
    required this.count,
    required this.score,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      count: Count.fromJson(json['count']),
      score: Score.fromJson(json['score']),
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
      totalCount: json['totalCount'],
      totalDailyCount: json['totalDailyCount'],
      totalWeeklyCount: json['totalWeeklyCount'],
      totalMonthlyCount: json['totalMonthlyCount'],
      totalCardboardPaper: json['totalCardboardPaper'],
      totalPlastic: json['totalPlastic'],
      totalGlass: json['totalGlass'],
      totalOther: json['totalOther'],
      totalMetal: json['totalMetal'],
      totalFoodScraps: json['totalFoodScraps'],
      totalOrganicYardWaste: json['totalOrganicYardWaste'],
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
      totalScore: json['totalScore'],
      cardboardPaperScore: json['cardboardPaperScore'],
      plasticScore: json['plasticScore'],
      glassScore: json['glassScore'],
      otherScore: json['otherScore'],
      metalScore: json['metalScore'],
      foodScrapsScore: json['foodScrapsScore'],
      organicYardWasteScore: json['organicYardWasteScore'],
    );
  }
}
