class ChandPoints {
  final String latitude;
  final String longitude;
  final String altitide;
  final String name;
  final String time;
  final String description;

  ChandPoints(this.latitude, this.longitude, this.altitide, this.name,
      this.time, this.description);

  ChandPoints.fromJson(Map<String, dynamic> json)
      : latitude = json["latitude"],
        longitude = json["longitude"],
        altitide = json["altitude"],
        name = json["name"],
        time = json["time"],
        description = json["description"];

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitide,
        "name": name,
        "time": time,
        "description": description,
      };
}
