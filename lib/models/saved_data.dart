class SavedData {
  final String localTrk;
  final String localWpt;
  final String driveTrk;
  final String driveWpt;

  SavedData(this.localTrk, this.localWpt, this.driveTrk, this.driveWpt);

  SavedData.fromJson(Map<String, dynamic>? json)
      : localTrk = json!["localTrk"],
        localWpt = json["localWpt"],
        driveTrk = json["driveTrk"],
        driveWpt = json["localTrk"];

  Map<String, dynamic> toJson() => {
        "localTrk": localTrk,
        "localWpt": localWpt,
        "driveTrk": driveTrk,
        "driveWpt": driveWpt,
      };
}
