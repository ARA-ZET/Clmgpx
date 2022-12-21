import 'dart:convert';
import 'dart:io';
import 'package:clmgpx/models/session_data.dart';
import 'package:clmgpx/models/saved_data.dart';
import 'package:flutter/foundation.dart';
import 'package:gpx/gpx.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static FileManager? _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  gpxconvert(List<Wpt> points) async {
    // create gpx-xml from object
    final gpx = Gpx();
    gpx.version = '1.1';
    gpx.creator = 'dart-gpx library';
    gpx.metadata = Metadata();
    gpx.metadata?.name = 'Letter boxes reached';
    gpx.metadata?.desc = 'location of some of world cities';
    gpx.metadata?.time = DateTime.now();
    gpx.wpts = points;

    // get GPX string
    final gpxString = GpxWriter().asString(gpx, pretty: true);

    return gpxString;
  }

  gpxconverttrk(dname, List<Wpt> points) {
    // create gpx-xml from object
    final gpx = Gpx();

    gpx.version = '1.1';
    gpx.creator = 'dart-gpx library';
    gpx.metadata = Metadata();
    gpx.metadata?.name = 'Movements of distributors';
    gpx.metadata?.desc = 'recording movements of distributors';
    gpx.metadata?.time = DateTime.now();

    gpx.trks = [
      Trk(name: dname, trksegs: [Trkseg(trkpts: points)])
    ];

    // get GPX string
    final gpxString = GpxWriter().asString(gpx, pretty: true);

    return gpxString;
  }

  kmlconverttrk(dname, List<Wpt> points) {
    // create gpx-xml from object
    final gpx = Gpx();

    gpx.version = '1.1';
    gpx.creator = 'dart-gpx library';
    gpx.metadata = Metadata();
    gpx.metadata?.name = 'Movements of distributors';
    gpx.metadata?.desc = 'recording movements of distributors';
    gpx.metadata?.time = DateTime.now();

    gpx.trks = [
      Trk(name: dname, trksegs: [Trkseg(trkpts: points)])
    ];

    // get GPX string
    final gpxString = KmlWriter().asString(gpx, pretty: true);

    return gpxString;
  }

  Future<String> get _directoryPath async {
    if (Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();
      return directory!.path;
    } else {
      Directory? directory = await getExternalStorageDirectory();
      return directory!.path;
    }
  }

  Future<String> get _supportDirectoryPath async {
    Directory directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  Future<File> myName(file) async {
    final path = await _directoryPath;
    return File('$path/$file');
  }

  Future<File> _jsonSupportFiles(file) async {
    final supportPath = await _supportDirectoryPath;
    return File('$supportPath/$file');
  }

  Future<String> readCount(file) async {
    String fileContent = '0';

    File name = await _jsonSupportFiles(file);

    if (await name.exists()) {
      try {
        fileContent = await name.readAsString();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return fileContent;
  }

  Future<List<Wpt>> readGpxFile(file) async {
    List<Wpt> fileContent = [];

    File name = await myName(file);

    if (await name.exists()) {
      try {
        String xmlstring = await name.readAsString();
        fileContent = GpxReader().fromString(xmlstring).wpts;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return fileContent;
  }

  Future<Map<String, dynamic>?> readJsonFile() async {
    String fileContent =
        '{"name": "arazetgpx", "date": "8 June", "cliet": "nodata", "targetarea": "nodata"}';

    File file = await _jsonSupportFiles("SessionData.json");

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return json.decode(fileContent);
  }

  Future<Map<String, dynamic>?> readJsonSupportFiles() async {
    String fileContent =
        '{"localTrk": "nodata", "localWpt": "nodata", "driveTrk": "nodata", "driveWpt": "nodata"}';

    File file = await _jsonSupportFiles("saved.json");

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return json.decode(fileContent);
  }

  Future<String> writeTextFile(fileName, file) async {
    String xmlstring = await gpxconvert(fileName);

    File name = await myName(file);

    name.writeAsString(xmlstring);
    return xmlstring;
  }

  Future<String> writeGpxTrk(dname, fileName, file) async {
    String xmlstring = await gpxconverttrk(dname, fileName);

    File name = await myName(file);

    name.writeAsString(xmlstring);
    return xmlstring;
  }

  Future<String> writeKmlTrk(dname, fileName, file) async {
    String xmlstring = await kmlconverttrk(dname, fileName);

    File name = await myName(file);

    name.writeAsString(xmlstring);
    return xmlstring;
  }

  Future<SessionData> writeJsonFile(name, date, client, area) async {
    final SessionData user = SessionData(name, date, client, area);

    File file = await _jsonSupportFiles("SessionData.json");
    await file.writeAsString(json.encode(user));
    return user;
  }

  Future<String> writeCount(number) async {
    String count = number;

    File file = await _jsonSupportFiles("Count.txt");
    await file.writeAsString(number);
    return count;
  }

  Future<SavedData> writeJsonSupportFiles(
      localTrk, localWpt, driveTrk, driveWpt) async {
    final SavedData savedData =
        SavedData(localTrk, localWpt, driveTrk, driveWpt);

    File file = await _jsonSupportFiles("saved.json");
    await file.writeAsString(json.encode(savedData));
    return savedData;
  }

  createDir(folder) async {
    final directoryName = folder;

    final docDir = await getExternalStorageDirectory();
    final myDir = Directory('${docDir!.path}/$directoryName');

    if (await myDir.exists()) {
      if (kDebugMode) {
        print(myDir.path);
      }
    }
    final dir = await myDir.create(recursive: true);
    if (kDebugMode) {
      print(dir.path);
    }
  }
}
