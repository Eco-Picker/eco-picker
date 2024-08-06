class Garbage {
  final int id;
  final String name;
  final String category;
  final String memo;
  final String pickedUpAt;
  double? latitude;
  double? longitude;

  Garbage({
    required this.id,
    required this.name,
    required this.category,
    required this.memo,
    required this.pickedUpAt,
    this.latitude,
    this.longitude,
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

  setPosition(double lat, double long) {
    latitude = lat;
    longitude = long;
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'memo': memo,
      'pickedUpAt': pickedUpAt,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class MapGarbage {
  final int garbageId;
  final String garbageCategory;
  final double longitude;
  final double latitude;

  MapGarbage({
    required this.garbageId,
    required this.garbageCategory,
    required this.longitude,
    required this.latitude,
  });

  factory MapGarbage.fromJson(Map<String, dynamic> json) {
    return MapGarbage(
      garbageId: json['garbageId'],
      garbageCategory: json['garbageCategory'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class GarbageLocation {
  final List<MapGarbage> garbageLocations;

  GarbageLocation({
    required this.garbageLocations,
  });

  factory GarbageLocation.fromJson(Map<String, dynamic> json) {
    var garbageJsonList = json['garbageLocations'] as List<dynamic>;

    List<MapGarbage> garbageLocations =
        garbageJsonList.map((item) => MapGarbage.fromJson(item)).toList();

    return GarbageLocation(garbageLocations: garbageLocations);
  }
}
