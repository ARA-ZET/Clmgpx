import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gpx/gpx.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import '../models/user_location.dart';
import '../services/file_manager.dart';

// Location provider
class LocationService with ChangeNotifier {
  late Wpt _currentLocation = Wpt();
  late Wpt _previousLocation = Wpt();

  Duration duration = const Duration();
  final List _distSum = [];
  List<Wpt> _trackpoints = [];
  Timer? timer;
  Timer? timerr;
  Timer? wtimer;

  double avgSpeed = 0.0;
  bool isRecording = false;
  Location location = Location();
  bool waitForAccurateLocation = true;

  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;
  List<Wpt> get trackpoints => _trackpoints;
  get timecount => duration;
  bool get isRecordingg => isRecording;
  Wpt get currentLocation => _currentLocation;
  double get distance =>
      _distSum.fold(0, (previous, current) => previous + current);

// Reset all the the track, timers and distance
  void resetData() {
    _trackpoints.clear();
    writeKmlTrack("dname", _trackpoints, "/Session Data/backuptrk.kml");
    duration = Duration.zero;
    timer?.cancel();
    isRecording = false;
    notifyListeners();
  }

// Get realtime location
  LocationService() {
    location.changeSettings(accuracy: LocationAccuracy.high, interval: 2000);
    location.enableBackgroundMode(enable: true);
    location.changeNotificationOptions(
        iconName: "@mipmap/ic_launcher",
        title: "Location service is running in background",
        channelName: "arazet",
        description: "arazet is currently running",
        onTapBringToFront: true);

// request permission to use location service
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
                  _previousLocation = _currentLocation,
                  _currentLocation = Wpt(
                    lat: locationData.latitude,
                    lon: locationData.longitude,
                    time: DateTime.fromMillisecondsSinceEpoch(
                        locationData.time!.toInt()),
                  ),
                ],
              )
            }
        });
    notifyListeners();
  }

  // Timer
  void addTime() {
    const addSeconds = 1;

    final seconds = duration.inSeconds + addSeconds;

    duration = Duration(seconds: seconds);
    notifyListeners();
  }

// starting the timer
  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(const Duration(seconds: 1),
        (_) => [addTime(), avgCal(), addDistance()]);
    isRecording = true;
    notifyListeners();
  }

// reset timer to zero
  void reset() {
    duration = const Duration();
    _trackpoints = [];
    notifyListeners();
  }

// Pause timer
  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer!.cancel();
    isRecording = false;
    notifyListeners();
  }

  void addPoint() async {
    Wpt point = _currentLocation;

    Wpt point0 = _previousLocation;

    if (point.lat != point0.lat) {
      _trackpoints.add(point);
    }
    notifyListeners();
  }

// calculating average speed in km/hr
  void avgCal() {
    double time = double.parse(duration.inSeconds.toString());
    avgSpeed = distance / time * 3600;

    notifyListeners();
  }

// Check if the distributor's location have changes and if there is Gps network
  void addDistance() async {
    Wpt point = _currentLocation;
    Wpt point0 = _previousLocation;

    if (point.lat != point0.lat && point.lon != point0.lon) {
      if (point.lat.toString() != "NO GPX FIX") {
        distanceCal();
        notifyListeners();
      }
    }
  }

// Calculate distance between two trackpoints
  void distanceCal() async {
    Wpt point = _currentLocation;
    Wpt point0 = _previousLocation;

    if (point.lat != point0.lat && point.lon != point0.lon) {
      if (point.lat != 0.0) {
        final dis =
            Haversine.haversine(point.lat, point.lon, point0.lat, point0.lon);
        if (dis <= 12) {
          _distSum.add(dis);
        }
      }
    }
    notifyListeners();
  }

//write .gpx tracklog to local files
  void writeTrack(String dname, List<Wpt> name, file) async {
    await FileManager().writeGpxTrk(dname, name, file);
    notifyListeners();
  }

//write .kml tracklog to local files
  void writeKmlTrack(String dname, List<Wpt> name, file) async {
    await FileManager().writeKmlTrk(dname, name, file);
    notifyListeners();
  }

  void startRecording({bool resets = true}) {
    if (resets) {
      reset();
    }
    timerr = Timer.periodic(const Duration(seconds: 8), (_) => addPoint());
    notifyListeners();
  }

  void stopRecording({bool resets = true}) {
    if (resets) {
      reset();
    }

    timerr!.cancel();
    notifyListeners();
  }

  void startWriteKml({bool resets = true}) {
    if (resets) {
      reset();
    }
    wtimer = Timer.periodic(
        const Duration(minutes: 5),
        (_) => writeKmlTrack(
            "traclog01", _trackpoints, "/Session Data/backuptrk.kml"));
    notifyListeners();
  }

  void stopWriteKml({bool resets = true}) {
    if (resets) {
      reset();
    }

    wtimer!.cancel();
    notifyListeners();
  }
}

class Haversine {
  static const R = 6372.8; // In kilometers

  static double haversine(lat1, lon1, lat2, lon2) {
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
