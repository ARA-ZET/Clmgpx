import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  final String name;

  final List<LatLng> polygon;

  Station(this.name, this.polygon);

  Station.fromJson(Map<String, dynamic>? json)
      : name = json!["name"],
        polygon = json["polygon"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "polygon": polygon,
      };
}
