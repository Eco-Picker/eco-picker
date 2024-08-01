class Garbage {
  final int id;
  final String name;
  final String category;
  final String memo;
  final String pickedUpAt;

  Garbage({
    required this.id,
    required this.name,
    required this.category,
    required this.memo,
    required this.pickedUpAt,
  });

  factory Garbage.fromJson(Map<String, dynamic> json) {
    return Garbage(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      memo: json['memo'],
      pickedUpAt: json['pickedUpAt'],
    );
  }
}
