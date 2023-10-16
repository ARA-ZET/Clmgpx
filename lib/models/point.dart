import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pmarker {
  final String name;

  final LatLng pmarker;

  Pmarker(this.name, this.pmarker);

  Pmarker.fromJson(Map<String, dynamic>? json)
      : name = json!["name"],
        pmarker = json["pmarker"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "pmarker": pmarker,
      };
}
