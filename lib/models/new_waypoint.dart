class NewWaypoint {
  final String latitude;
  final String longitude;
  final String altitide;
  final String name;
  final String time;

  NewWaypoint(
      this.latitude, this.longitude, this.altitide, this.name, this.time);

  NewWaypoint.fromJson(Map<String, dynamic> json)
      : latitude = json["latitude"],
        longitude = json["longitude"],
        altitide = json["altitude"],
        name = json["name"],
        time = json["time"];

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitide,
        "name": name,
        "time": time,
      };
}
