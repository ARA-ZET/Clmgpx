class SessionData {
  String? name;
  String? date;
  String? client;
  String? area;

  SessionData(this.name, this.date, this.client, this.area);

  SessionData.fromJson(Map<String, dynamic>? json)
      : name = json!["name"],
        date = json["date"],
        client = json["client"],
        area = json["area"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "client": client,
        "area": area,
      };
}
