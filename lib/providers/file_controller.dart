import 'dart:async';
import 'dart:io';
import 'package:clmgpx/models/saved_data.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:location/location.dart';
import '../models/user_location.dart';
import 'package:path/path.dart' as p;
import 'package:clmgpx/models/session_data.dart';
import 'package:clmgpx/services/file_manager.dart';
import 'package:gpx/gpx.dart';
import 'package:clmgpx/services/google_auth_client.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;

class FileController with ChangeNotifier {
  //Data stored
  String _text = "";
  SessionData? _sessionData =
      SessionData("arazetgpx", "date", "arazet", "no data");
  SavedData? savedData = SavedData("nodata", "nodata", "nodata", "nodata");
  List<Wpt> _waypoints = [];
  int _count = 0;

  bool ignoreLastKnowPosition = false;
  Location location = Location();
  sign_in.GoogleSignInAccount? _account;
  bool isLogged = false;
  String lastSavedTrkLocal = "nodata";
  String lastSavedwptLocal = "nodata";
  String lastSavedTrkDrive = "nodata";
  String lastSavedwptDrive = "nodata";
  StreamSubscription<HardwareButton>? subscription;
  Wpt userLocation = LocationService().currentLocation;
  int tapCount = 0;

// file getter methods
  String get text => _text;
  SessionData? get sessionData => _sessionData;
  int get count => _count;
  List<Wpt> get waypoints => _waypoints;
  sign_in.GoogleSignInAccount? get account => _account;

// Reset session data
  void deleteData() {
    writesession("arazetgpx", "date", "arazet", "no data");
    _waypoints.clear();
    _count = 0;
    writeText(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();
    readCount();
    readSession();
    notifyListeners();
  }

// add only one waypoint
  void icreament(lat, lon, alt, name, time) async {
    Wpt waypoint = Wpt(lat: lat, lon: lon, ele: alt, name: name, time: time);
    _waypoints.add(waypoint);
    _count++;

    writeText(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();

    notifyListeners();
  }

// add Multiple waypoints if there are many letter boxes
  void multi(int point, UserLocation userLocation) {
    for (var i = 0; i < point; i++) {
      Wpt waypoint = Wpt(
          lat: double.parse(userLocation.latitude),
          lon: double.parse(userLocation.longitude),
          ele: double.parse(userLocation.altitude),
          name: "Letter_Box ${count + 1}",
          time: DateTime.parse(userLocation.time));

      _waypoints.add(waypoint);
      _count++;
    }
    writeText(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();

    notifyListeners();

    debugPrint(_waypoints[1].desc);
  }

// Listen to hardware volume button to add waypoints
  void startListening() {
    subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
      if (event == HardwareButton.volume_up) {
        tapCount++;
        if (tapCount.isEven) {
          icreament(userLocation.lat, userLocation.lon, userLocation.ele,
              "LetterBox", userLocation.time);
        }
      }
    });
  }

// Stop listening to volume button click
  void stopListening() {
    subscription?.cancel();
  }

// read number of waypoints from the local txt file
  readCount() async {
    _count = int.parse(await FileManager().readCount("Count.txt"));
    notifyListeners();
  }

// write number of waypoints to local txt file
  writeCount() async {
    await FileManager().writeCount(_count.toString());
    notifyListeners();
  }

// read gpx file
  readGpx(file) async {
    _waypoints = await FileManager().readGpxFile(file);
    notifyListeners();
  }

// write gpx file
  writeText(List<Wpt> name, file) async {
    _text = await FileManager().writeTextFile(name, file);
    notifyListeners();
  }

// read session info
  readSession() async {
    final result = await FileManager().readJsonFile();
    if (result != null) {
      _sessionData = SessionData.fromJson(await FileManager().readJsonFile());
    }

    notifyListeners();
  }

// read file that contains last exported files in drive and local files
  readSupportFiles() async {
    final result = await FileManager().readJsonSupportFiles();
    if (result != null) {
      savedData =
          SavedData.fromJson(await FileManager().readJsonSupportFiles());
      lastSavedTrkLocal = savedData!.localTrk;
      lastSavedwptLocal = savedData!.localWpt;
      lastSavedTrkDrive = savedData!.driveTrk;
      lastSavedwptDrive = savedData!.driveWpt;
    } else {
      return null;
    }
    notifyListeners();
  }

// Write session info
  writesession(name, date, client, area) async {
    _sessionData = await FileManager().writeJsonFile(name, date, client, area);
    notifyListeners();
  }

// write exporting history
  writeSupportFiles(localTrk, localWpt, driveTrk, driveWpt) async {
    savedData = await FileManager()
        .writeJsonSupportFiles(localTrk, localWpt, driveWpt, driveWpt);
    notifyListeners();
  }

// create new folder
  createFolder(folder) async {
    FileManager().createDir(folder);
    notifyListeners();
  }

  // signin user via google sign
  void signInUser() async {
    final googleSignIn =
        sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveFileScope]);
    _account = await googleSignIn.signIn();
    isLogged = true;

    notifyListeners();
  }

// signout user to change account or not to accidently upload files
  void signOutUser() async {
    final googleSignIn =
        sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveFileScope]);
    _account = await googleSignIn.signOut();
    isLogged = false;

    notifyListeners();
  }

//loggic to uppload upload files to drive
// check file be uploaded are not in drive already to avoid duplicates of files being uploaded
  void driveFile() async {
    final googleSignIn =
        sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveFileScope]);
    _account = await googleSignIn.signIn();
    isLogged = true;
    final authHeaders = await _account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);
    File trackFile =
        await FileManager().myName("Session/$lastSavedTrkLocal.gpx");
    File wptFile = await FileManager().myName("Session/$lastSavedwptLocal.gpx");

    Future<String?> getFolderId(drive.DriveApi driveApi) async {
      const mimeType = "application/vnd.google-apps.folder";
      String folderName = "Dailies";

      try {
        final found = await driveApi.files.list(
          q: "mimeType = '$mimeType' and name = '$folderName'",
          $fields: "files(id, name)",
        );
        final files = found.files;
        if (files == null) {
          if (kDebugMode) {
            print("Sign-in first Error");
          }
          return null;
        }

        // The folder already exists
        if (files.isNotEmpty) {
          return files.first.id;
        }

        // Create a folder
        drive.File folder = drive.File();
        folder.name = folderName;
        folder.mimeType = mimeType;
        final folderCreation = await driveApi.files.create(folder);
        debugPrint("Folder ID: ${folderCreation.id}");

        return folderCreation.id;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }

// upload specific file to drive
    void uploadFileToGoogleDrive(file) async {
      String? folderId = await getFolderId(driveApi);
      if (folderId == null) {
        debugPrint("Sign-in first Error");
      } else {
        drive.File fileToUpload = drive.File();
        fileToUpload.parents = [folderId];
        fileToUpload.name = p.basename(file.absolute.path);
        var response = await driveApi.files.create(
          fileToUpload,
          uploadMedia: drive.Media(
            file.openRead(),
            file.lengthSync(),
          ),
        );
        if (kDebugMode) {
          print(response);
        }
      }

      notifyListeners();
    }

    uploadFileToGoogleDrive(wptFile);
    uploadFileToGoogleDrive(trackFile);

    lastSavedTrkDrive = lastSavedTrkLocal;
    lastSavedwptDrive = lastSavedwptLocal;
    writeSupportFiles(lastSavedTrkLocal, lastSavedTrkDrive, lastSavedwptLocal,
        lastSavedwptDrive);

    notifyListeners();
  }
}
