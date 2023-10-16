import 'dart:convert';
import 'dart:io';

import 'package:clmgpx/models/session_data.dart';
import 'package:clmgpx/models/stations.dart';
import 'package:clmgpx/models/point.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:path_provider/path_provider.dart';
import '../models/saved_data.dart';
import 'package:xml/xml.dart';
// import '../models/saved_file,dart';

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
    gpx.metadata?.desc =
        'this records positions of every letterbox our distributors have reached';
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

  gpxconvertbackup(dname, List<Wpt> wpoints, List<Wpt> tpoints) {
    // create gpx-xml from object
    final gpx = Gpx();

    gpx.version = '1.1';
    gpx.creator = 'dart-gpx library';
    gpx.metadata = Metadata();
    gpx.metadata?.name = 'Movements of distributors';
    gpx.metadata?.desc = 'recording movements of distributors';
    gpx.metadata?.time = DateTime.now();
    gpx.trks = [
      Trk(name: dname, trksegs: [Trkseg(trkpts: tpoints)])
    ];
    gpx.wpts = wpoints;
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

  // Future<List<List<LatLng>>> readKmlFile() async {
  //   File name = await myName("/Session Data/stations.kml");
  //   final kmlString = await name.readAsString();
  //   final document = XmlDocument.parse(kmlString);
  //   final polygonElements = document.findAllElements("Polygon").toList();
  //   // debugPrint(polygonElements.toString());
  //   final polygonCoordinates = polygonElements.map((polygonElement) {
  //     final coordinateElements = polygonElement.findAllElements('coordinates');
  //     final coordinateString =
  //         coordinateElements.first.text.replaceAll(",0", "").trim();

  //     final coordinateList = coordinateString.split(' ').toList();
  //     coordinateList.removeWhere((element) => element.length < 2);

  //     // debugPrint(coordinateList.toString());

  //     // Create a list of LatLng coordinates from the coordinate string
  //     final coordinates = coordinateList.map((coordinate) {
  //       final latLngList = coordinate.split(',');
  //       latLngList.removeWhere((number) => number == "0");
  //       // debugPrint(latLngList.length.toString());

  //       final lng = double.tryParse(latLngList[0]);
  //       final lat = double.tryParse(latLngList[1]);
  //       return LatLng(lat!, lng!);
  //     }).toList();

  //     return coordinates;
  //   }).toList();
  //   // debugPrint(polygonCoordinates.toString());
  //   return polygonCoordinates;
  // }

  // Future<List<Station>> readKmlFull() async {
  //   File name = await myName("/Session Data/stations.kml");
  //   final kmlString = await name.readAsString();
  //   final document = XmlDocument.parse(kmlString);
  //   final polygonElements = document.findAllElements("Placemark").toList();
  //   // debugPrint(polygonElements.toString());
  //   final polygonCoordinates = polygonElements.map((polygonElement) {
  //     final coordinateElements = polygonElement.findAllElements('coordinates');
  //     final nameElements =
  //         polygonElement.findAllElements('name').first.innerText;

  //     final coordinateString =
  //         coordinateElements.first.text.replaceAll(",0", "").trim();

  //     final coordinateList = coordinateString.split(' ').toList();
  //     coordinateList.removeWhere((element) => element.length < 2);

  //     // debugPrint(coordinateList.toString());

  //     // Create a list of LatLng coordinates from the coordinate string
  //     final coordinates = coordinateList.map((coordinate) {
  //       final latLngList = coordinate.split(',');
  //       latLngList.removeWhere((number) => number == "0");
  //       // debugPrint(latLngList.length.toString());

  //       final lng = double.tryParse(latLngList[0]);
  //       final lat = double.tryParse(latLngList[1]);
  //       return LatLng(lat!, lng!);
  //     }).toList();
  //     final pointData = Station(nameElements.toString(), coordinates);

  //     return pointData;
  //   }).toList();
  //   // debugPrint(polygonCoordinates.toString());
  //   return polygonCoordinates;
  // }

  // Future<List<Pmarker>> readKmlPoints() async {
  //   File name = await myName("/Session Data/points.kml");
  //   final kmlString = await name.readAsString();
  //   final document = XmlDocument.parse(kmlString);
  //   final polygonElements = document.findAllElements("Placemark").toList();
  //   // debugPrint(polygonElements.toString());
  //   final polygonCoordinates = polygonElements.map((polygonElement) {
  //     final coordinateElements = polygonElement.findAllElements('coordinates');
  //     final nameElements =
  //         polygonElement.findAllElements('name').first.innerText;

  //     final coordinateString =
  //         coordinateElements.first.text.replaceAll(",0", "").trim();

  //     final coordinateList = coordinateString.split(' ').toList();
  //     coordinateList.removeWhere((element) => element.length < 2);

  //     // debugPrint(coordinateList.toString());

  //     // Create a list of LatLng coordinates from the coordinate string
  //     final coordinates = coordinateList.map((coordinate) {
  //       final latLngList = coordinate.split(',');
  //       latLngList.removeWhere((number) => number == "0");
  //       // debugPrint(latLngList.length.toString());

  //       final lng = double.tryParse(latLngList[0]);
  //       final lat = double.tryParse(latLngList[1]);
  //       return LatLng(lat!, lng!);
  //     }).toList();
  //     final pointData = Pmarker(nameElements.toString(), coordinates[0]);

  //     return pointData;
  //   }).toList();
  //   // debugPrint(polygonCoordinates.toString());
  //   return polygonCoordinates;
  // }

  Future<List<String>> readKmlPointsNames() async {
    File name = await myName("/Session Data/points.kml");
    final kmlString = await name.readAsString();
    final document = XmlDocument.parse(kmlString);
    final polygonElements = document.findAllElements("Placemark").toList();
    // debugPrint(polygonElements.toString());
    final polygonCoordinates = polygonElements.map((polygonElement) {
      final nameElements =
          polygonElement.findAllElements('name').first.innerText;

      return nameElements;
    }).toList();
    // debugPrint(polygonCoordinates.toString());
    return polygonCoordinates;
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

  Future<List<Wpt>> readGpxTrk(file) async {
    List<Wpt> fileContent = [];
    File name = await myName(file);
    if (await name.exists()) {
      try {
        String xmlstring = await name.readAsString();
        fileContent =
            GpxReader().fromString(xmlstring).trks[0].trksegs[0].trkpts;
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
        '{"name": "arazetgpx", "date": "16 Jan", "cliet": "nodata", "targetarea": "nodata"}';

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

  // Future<Map<List<SavedFile>, dynamic>?> readHistory() async {
  //   String fileContent = '';

  //   File file = await _jsonSupportFiles("SavedHistory.json");

  //   if (await file.exists()) {
  //     try {
  //       fileContent = await file.readAsString();
  //       return json.decode(fileContent);
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   }

  //   return json.decode(fileContent);
  // }

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

  Future<String> writeWptFile(fileName, file) async {
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

  Future<String> writeGpxBackup(dname, wpoints, tpoints, file) async {
    String xmlstring = await gpxconvertbackup(dname, wpoints, tpoints);
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

  Future<SessionData> writeJsonFile(
    name,
    date,
    client,
    cientmap,
  ) async {
    final SessionData user = SessionData(
      name,
      date,
      client,
      cientmap,
    );

    File file = await _jsonSupportFiles("SessionData.json");
    await file.writeAsString(json.encode(user));
    return user;
  }

  Future<SavedData> writeJsonSupportFiles(
      localTrk, localWpt, driveTrk, driveWpt) async {
    final SavedData savedData =
        SavedData(localTrk, localWpt, driveTrk, driveWpt);
    File file = await _jsonSupportFiles("saved.json");
    await file.writeAsString(json.encode(savedData));
    return savedData;
  }

  // Future<List<SavedFile>> writeHistory(List<SavedFile> savedLocal) async {
  //   List<SavedFile> savedfiles = savedLocal;

  //   File file = await _jsonSupportFiles("SavedHistory.json");
  //   await file.writeAsString(json.encode(savedLocal));
  //   return savedfiles;
  // }

  Future<String> writeCount(number) async {
    String count = number;

    File file = await _jsonSupportFiles("Count.txt");
    await file.writeAsString(number);
    return count;
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
