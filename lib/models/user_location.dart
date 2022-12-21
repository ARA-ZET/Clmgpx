class UserLocation {
  final String latitude;
  final String longitude;
  final String altitude;
  final String speed;
  final String time;
  final String accuracy;

  UserLocation(
    this.latitude,
    this.longitude,
    this.altitude,
    this.speed,
    this.time,
    this.accuracy,
  );

  UserLocation.fromJson(Map<String, dynamic> json)
      : latitude = json["latitude"],
        longitude = json["longitude"],
        altitude = json["altitude"],
        speed = json["speed"],
        time = json["time"],
        accuracy = json["accuracy"];

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "altitude": altitude,
        "speed": speed,
        "time": time,
        "accuracy": accuracy,
      };
}
