import 'dart:async';
import 'dart:io';
import 'package:clmgpx/models/point.dart';
import 'package:clmgpx/models/stations.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/saved_data.dart';
import 'package:clmgpx/models/session_data.dart';
import 'package:clmgpx/services/file_manager.dart';
import 'package:gpx/gpx.dart';
import 'package:clmgpx/services/google_auth_client.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as sign_in;
import 'package:path/path.dart' as p;

class FileController with ChangeNotifier {
  //Data stored

  SessionData? _sessionData =
      SessionData("arazetgpx", "date", "arazet design", "focus corner");
  SavedData? _savedData = SavedData("nodata", "nodata", "nodata", "nodata");

  StreamSubscription<HardwareButton>? subscription;
  Wpt userLocation = LocationService().currentLocation;
  int tapCount = 0;
  sign_in.GoogleSignInAccount? _account;
  bool isLogged = false;
  bool ignoreLastKnowPosition = false;
  late int _progress = 0;
  late String _uploading = "     Uploading track...";
  late Color _color = Colors.red;
  late List<List<LatLng>> _polygons = [];
  late List<Station> _polyList = [];
  late List<Pmarker> _pointList = [];
  late List<String> _nameList = [];
  String _lastName = "";

  // List<SavedFile> _savedLocal = [];

// file getter methods

  SessionData? get sessionData => _sessionData;
  int get progress => _progress;
  String get uploading => _uploading;
  Color get color => _color;
  List<List<LatLng>> get polygons => _polygons;
  List<Station> get polyList => _polyList;
  List<Pmarker> get pointList => _pointList;
  List<String> get nameList => _nameList;
  String get lastName => _lastName;

  SavedData? get savedData => _savedData;
  sign_in.GoogleSignInAccount? get account => _account;
  // List<SavedFile> get savedLocal => _savedLocal;

// Reset session data
  void deleteData() {
    writesession("arazetgpx", "date", "client", 'clientmap');
    readSession();
    notifyListeners();
  }

  // Listen to hardware volume button to add waypoints
  // void startListening() {
  //   subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
  //     if (event == HardwareButton.volume_up) {
  //       tapCount++;
  //       if (tapCount.isEven) {
  //         LocationService().increment();
  //       }
  //     }
  //   });
  //   notifyListeners();
  // }

// Stop listening to volume button click
  // void stopListening() {
  //   subscription?.cancel();
  // }

// read session info
  readSession() async {
    final result = await FileManager().readJsonFile();
    if (result != null) {
      _sessionData = SessionData.fromJson(await FileManager().readJsonFile());
    }

    notifyListeners();
  }

// Write session info
  void writesession(name, date, client, cientmap) async {
    await FileManager().writeJsonFile(name, date, client, cientmap);
    readSession();
    notifyListeners();
  }

  // kmlreader() async {
  //   _polygons = await FileManager().readKmlFile();
  //   notifyListeners();
  // }

  // kmlFull() async {
  //   _polyList = await FileManager().readKmlFull();
  //   notifyListeners();
  // }

  // kmlPoints() async {
  //   _pointList = await FileManager().readKmlPoints();
  //   notifyListeners();
  // }

  // pointsNames() async {
  //   _nameList = await FileManager().readKmlPointsNames();

  //   notifyListeners();
  // }

  updateName(String name) async {
    _lastName = name;
    notifyListeners();
  }

//read history of recently saved files
  readSupportFiles() async {
    final result = await FileManager().readJsonSupportFiles();
    if (result != null) {
      _savedData =
          SavedData.fromJson(await FileManager().readJsonSupportFiles());
    } else {
      return null;
    }
    notifyListeners();
  }

// update list of recently saved files
  writeSupportFiles(localTrk, localWpt, driveTrk, driveWpt) async {
    _savedData = await FileManager()
        .writeJsonSupportFiles(localTrk, localWpt, driveWpt, driveWpt);

    notifyListeners();
  }

  //   readHistory() async {
  //   final result = await FileManager().readHistory();
  //   if (result != null) {
  //     _savedLocal =
  //         SavedFile.fromJson(await FileManager().readHistory());
  //   } else {
  //     return null;
  //   }
  //   notifyListeners();
  // }

  // writeFileHistory(List<SavedFile> savedLocal) async {
  //   _savedLocal = await FileManager().writeHistory(savedLocal);

  //   notifyListeners();
  // }

// create new folder in Local Directory
  void createFolder(folder) async {
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

// signout user to change account or keep user signed out
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
    _progress = 0;
    _color = Colors.red;
    final googleSignIn =
        sign_in.GoogleSignIn.standard(scopes: [drive.DriveApi.driveFileScope]);
    _account = await googleSignIn.signIn();
    isLogged = true;
    _progress = _progress + 10;
    _uploading = "Connecting....";
    _color = Colors.blue;
    final authHeaders = await _account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    // Future<String?> getFolderId(drive.DriveApi driveApi) async {
    //   const mimeType = "application/vnd.google-apps.folder";
    //   String folderName = "Dailies";

    //   try {
    //     final found = await driveApi.files.list(
    //       q: "mimeType = '$mimeType' and name = '$folderName'",
    //       $fields: "files(id, name)",
    //     );
    //     final files = found.files;
    //     if (files == null) {
    //       return null;
    //     }

    //     // The folder already exists
    //     if (files.isNotEmpty) {
    //       return files.first.id;
    //     }

    //     // Create a folder
    //     drive.File folder = drive.File();
    //     folder.name = folderName;
    //     folder.mimeType = mimeType;
    //     final folderCreation = await driveApi.files.create(folder);
    //     debugPrint("Folder ID: ${folderCreation.id}");

    //     return folderCreation.id;
    //   } catch (e) {
    //     debugPrint(e.toString());
    //     return null;
    //   }
    // }

    void uploadFileToGoogleDrive(file) async {
      String? folderId = "1FSxLLV7z7m0jmoPuPA4vixlecBArod6m";
      // ignore: unnecessary_null_comparison

      drive.File fileToUpload = drive.File();
      fileToUpload.parents = [folderId];
      fileToUpload.name = p.basename(file.absolute.path);
      var response = await driveApi.files.create(fileToUpload,
          uploadMedia: drive.Media(
            file.openRead(),
            file.lengthSync(),
          ));

      if (response.name.toString()[0] == "T") {
        _progress += 40;
        _uploading = "    Files uploaded";
        _color = Colors.green;
      }
      if (response.name.toString()[0] == "W") {
        _progress += 50;
        _uploading = "    Files uploaded";
        _color = Colors.green;
      }

      if (kDebugMode) {
        debugPrint(response.name.toString());
      }
      notifyListeners();
    }

// list of file that need to be uploaded
    List uploadList = [savedData!.localTrk, savedData!.localWpt];
// upload multiple file into google drive
    void uploadMulti() async {
      for (var i = 0; i < uploadList.length; i++) {
        File ftu = await FileManager().myName("Session/${uploadList[i]}");

        uploadFileToGoogleDrive(ftu);
        await writeSupportFiles(savedData!.localTrk, savedData!.localWpt,
            savedData!.localTrk, savedData!.localWpt);
      }
    }

    uploadMulti();

    notifyListeners();
  }
}
