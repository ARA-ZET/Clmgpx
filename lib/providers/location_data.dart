import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:gpx/gpx.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../models/user_location.dart';
import '../services/file_manager.dart';

// Location provider
class LocationService with ChangeNotifier {
  late Wpt _currentLocation = Wpt();
  Location location = Location();

  late Wpt _lastSaved = Wpt();
  Duration duration = const Duration();
  List<Wpt> _trackpoints = [];
  Timer? timerr;
  Timer? wtimer;
  bool _isRecording = false;
  bool _isConnected = false;
  // Location location = Location();
  bool ignoreLastKnownPosition = false;
  double _distance = 0;
  List<Wpt> _waypoints = [];
  int _count = 0;
  Duration _workingTime = const Duration();
  DateTime _startTime = DateTime.now();

//broadcasting location stream
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

// get methods
  Stream<UserLocation> get locationStream => _locationController.stream;
  List<Wpt> get trackpoints => _trackpoints;
  bool get isRecording => _isRecording;
  bool get isConnected => _isConnected;
  Wpt get currentLocation => _currentLocation;
  double get distance => _distance;
  Duration get workingTime => _workingTime;
  int get count => _count;
  List<Wpt> get waypoints => _waypoints;

//REALTIME LOCATION SERVICE

// Get realtime location
  LocationService() {
    location.changeSettings(
        accuracy: LocationAccuracy.navigation, interval: 4000);
    location.enableBackgroundMode(enable: true);
    location.changeNotificationOptions(
        iconName: "@mipmap/ic_launcher",
        title: "Location service is running in background",
        channelName: "arazet",
        description: "arazet is currently running",
        onTapBringToFront: true);

    location.requestPermission().then((granted) => {
          if (granted == granted)
            {
              location.onLocationChanged.listen(
                (locationData) => [
                  _locationController.add(
                    UserLocation(
                      locationData.latitude.toString(),
                      locationData.longitude.toString(),
                      locationData.altitude.toString(),
                      locationData.speed.toString(),
                      DateTime.fromMillisecondsSinceEpoch(
                              locationData.time!.toInt())
                          .toString(),
                      locationData.accuracy!.toStringAsFixed(1),
                    ),
                  ),
                  _currentLocation = Wpt(
                    lat: locationData.latitude,
                    lon: locationData.longitude,
                    time: DateTime.fromMillisecondsSinceEpoch(
                        locationData.time!.toInt()),
                  ),
                  debugPrint("Location ${locationData.latitude.toString()}")
                ],
              )
            }
        });
    notifyListeners();
  }

////WORKING STATE AND LOGICS

  // Reset all the the track, timers and distance
  void resetData() {
    _waypoints.clear();
    _count = 0;
    writeWpts(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();
    readCount();
    _trackpoints.clear();
    writeTrack("dname", _trackpoints, "/Session Data/backuptrk.gpx");
    duration = Duration.zero;
    _workingTime = Duration.zero;
    _isRecording = false;
    notifyListeners();
  }

  // monitoring wether device have gps connection or not
  gpsState() async {
    if (currentLocation.lat.toString() != "0.0" || currentLocation.lat != 0.0) {
      if (currentLocation.time != null) {
        final diff = DateTime.now().difference(currentLocation.time!).inSeconds;

        if (diff >= 60) {
          _isConnected = false;
        } else {
          _isConnected = true;
        }
      }
    } else {
      _isConnected = false;
    }

    notifyListeners();
  }

//// TRACKLOG DATA RECORDING

// reset timer to zero
  void reset() {
    duration = const Duration();
    _trackpoints = [];
    notifyListeners();
  }

  void addPoint() async {
    Wpt point = _currentLocation;

    Wpt point0 = _lastSaved;

    if (point.lat != point0.lat && point.lon != point0.lon) {
      _trackpoints.add(point);
      _isConnected = true;
      _lastSaved = _currentLocation;
    }
    notifyListeners();
  }

  //write .gpx tracklog to local files
  void writeTrack(String dname, List<Wpt> name, file) async {
    await FileManager().writeGpxTrk(dname, name, file);
    notifyListeners();
  }

//read gpx track
  readGpxTrk(file) async {
    _trackpoints = await FileManager().readGpxTrk(file);
    notifyListeners();
  }

  //write .kml tracklog to local files
  void writeKmlTrack(String dname, List<Wpt> name, file) async {
    await FileManager().writeKmlTrk(dname, name, file);
    notifyListeners();
  }

  //write .kml tracklog to local files
  void writeBackup(String dname, file) {
    List<Wpt> wpoints = _waypoints;
    List<Wpt> tpoints = _trackpoints;
    FileManager().writeGpxBackup(dname, wpoints, tpoints, file);
    resetData();
    reset();
    notifyListeners();
  }

// start recording track after 5 seconds
  void startRecording({bool resets = true}) {
    if (resets) {
      reset();
    }
    timerr = Timer.periodic(
        const Duration(seconds: 5),
        (_) => [
              addPoint(),
              gpsState(),
            ]);

    _isRecording = true;
    _startTime = DateTime.now();
    notifyListeners();
  }

//Pause track record
  void stopRecording({bool resets = true}) {
    if (resets) {
      reset();
    }

    timerr!.cancel();
    _isRecording = false;
    // timming(0);
    notifyListeners();
  }

// writting tracklog to local backup file
  void startWriteGpx({bool resets = true}) {
    if (resets) {
      reset();
    }
    wtimer = Timer.periodic(
        const Duration(minutes: 5),
        (_) => writeTrack(
            "traclog01", _trackpoints, "/Session Data/backuptrk.gpx"));
    notifyListeners();
  }

//pause track log recording
  void stopWriteKml({bool resets = true}) {
    if (resets) {
      reset();
    }
    writeTrack("traclog01", _trackpoints, "/Session Data/backuptrk.gpx");
    wtimer!.cancel();
    notifyListeners();
  }

  //// WAYPOINTS DATA

  //request Location if current Location == 0.0 or NO Gpx Fix

  void increment(name) async {
    Wpt waypoint = Wpt(
        lat: _currentLocation.lat,
        lon: _currentLocation.lon,
        ele: _currentLocation.ele,
        name: "$name",
        time: _currentLocation.time);
    _waypoints.add(waypoint);
    _count++;

    writeWpts(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();
    notifyListeners();
  }

  void chandIncrement(name, desc) async {
    Wpt waypoint = Wpt(
        lat: _currentLocation.lat,
        lon: _currentLocation.lon,
        ele: _currentLocation.ele,
        name: name,
        time: _currentLocation.time,
        desc: desc);
    _waypoints.add(waypoint);
    _count++;

    writeWpts(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();
    notifyListeners();
  }

  // add Multiple waypoints if there are many letter boxes
  void multi(int point) {
    for (var i = 0; i < point; i++) {
      Wpt waypoint = Wpt(
          lat: _currentLocation.lat,
          lon: _currentLocation.lon,
          ele: _currentLocation.ele,
          name: "Letter_box${count + 1}",
          time: _currentLocation.time);

      _waypoints.add(waypoint);
      _count++;
    }
    writeWpts(_waypoints, "/Session Data/backupwpt.gpx");
    writeCount();

    notifyListeners();

    debugPrint(_waypoints[1].desc);
  }

  // read gpx file
  readGpx(file) async {
    _waypoints = await FileManager().readGpxFile(file);
    notifyListeners();
  }

  // write gpx file
  void writeWpts(List<Wpt> name, file) async {
    await FileManager().writeWptFile(name, file);

    notifyListeners();
  }
// read number of waypoints from the local txt file

  readCount() async {
    _count = int.parse(await FileManager().readCount("Count.txt"));
    notifyListeners();
  }

  // write number of waypoints to local txt file
  void writeCount() async {
    await FileManager().writeCount(_count.toString());
    notifyListeners();
  }

  //// CALCULATORS

// calculating working time
  // void timming(int mode) {
  //   if (mode == 1) {
  //     if (_isRecording == true) {
  //       DateTime stoptime = DateTime.now();
  //       Duration dif = stoptime.difference(_startTime);
  //       _workingTime = _workingTime + dif;
  //       _startTime = DateTime.now();
  //     }
  //   }

  //   if (mode == 0) {
  //     DateTime stoptime = DateTime.now();
  //     Duration dif = stoptime.difference(_startTime);
  //     _workingTime = _workingTime + dif;
  //   }

  //   debugPrint(_workingTime.toString());
  //   notifyListeners();
  // }

// calculate distance once when the distributor wants infor

  distanceCal() {
    _distance = 0;
    _workingTime = const Duration();
    for (int i = 0; i < _trackpoints.length - 1; i++) {
      var start = _trackpoints[i];
      var end = _trackpoints[i + 1];
      final dist =
          Haversine.haversine(start.lat!, start.lon!, end.lat!, end.lon!);
      Duration dif = end.time!.difference(start.time!);
      if (dist < 0.1) {
        _distance += dist;
        if (dif <= const Duration(minutes: 1)) {
          _workingTime += dif;
        }
      }
    }
    notifyListeners();
  }
}

// fomular to calculate between to sets of coordiantes
class Haversine {
  static const R = 6372.8; // In kilometers
  static double haversine(double lat1, double lon1, double lat2, double lon2) {
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
