class SessionData {
  String? name;
  String? date;
  String? client;
  String? clientmap;

  SessionData(this.name, this.date, this.client, this.clientmap);

  SessionData.fromJson(Map<String, dynamic>? json)
      : name = json!["name"],
        date = json["date"],
        client = json["client"],
        clientmap = json["clientmap"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "client": client,
        "clientmap": clientmap,
      };
}
