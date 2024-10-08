class Garbage {
  int? id;
  final String name;
  final String category;
  final String pickedUpAt;
  double? latitude;
  double? longitude;

  Garbage({
    this.id,
    required this.name,
    required this.category,
    required this.pickedUpAt,
    this.latitude,
    this.longitude,
  });

  factory Garbage.fromJson(Map<String, dynamic> json) {
    return Garbage(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      pickedUpAt: json['pickedUpAt'],
      latitude: json['latitude'],
      longitude: json['longitude'],
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
