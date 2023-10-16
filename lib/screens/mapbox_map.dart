import 'package:clmgpx/providers/location_data.dart';
import 'package:clmgpx/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

class Mapboxmaps extends StatefulWidget {
  const Mapboxmaps({super.key});

  @override
  State<Mapboxmaps> createState() => _MapboxmapsState();
}

class _MapboxmapsState extends State<Mapboxmaps> {
  late CameraPosition _initialCameraPosition;
  late MapboxMapController mapController;
  var currentLoctioan = const LatLng(-33.916852, 18.510861);

  void downloadOfflineRegions() async {
    // Create the offline region definition
    final offlineRegionDefinition = OfflineRegionDefinition(
      bounds: LatLngBounds(
        southwest: const LatLng(-34.6503, 18.2324),
        northeast: const LatLng(-33.5992, 20.1664),
      ),
      minZoom: 10,
      maxZoom: 15,
      mapStyleUrl: "mapbox://styles/arazetdesign/clij33z5j00c201r17cdrejen",
    );

    // Create the offline region metadata

    // Create an offline region callback

    onEvent(DownloadRegionStatus status) {
      if (status.runtimeType == Success) {
        debugPrint("success");
      } else if (status.runtimeType == InProgress) {
        int progress = (status as InProgress).progress.round();
        debugPrint(progress.toString());
        // ...
      } else if (status.runtimeType == Error) {
        debugPrint(status.toString());
      }
    }

    downloadOfflineRegion(offlineRegionDefinition,
        metadata: {"name": "WesternCape"},
        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
        onEvent: onEvent);
    return;
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(target: currentLoctioan, zoom: 14);
    downloadOfflineRegions();
  }

  @override
  Widget build(BuildContext context) {
    final trk = context.watch<LocationService>().trackpoints;
    late List<LatLng> polylineCoordinates =
        trk.map((wpt) => LatLng(wpt.lat!, wpt.lon!)).toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          backgroundColor: Colors.blueGrey.shade900,
          title: const Wcount(),
        ),
      ),
      body: MapboxMap(
        styleString: "mapbox://styles/arazetdesign/clij33z5j00c201r17cdrejen",
        accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
        initialCameraPosition: _initialCameraPosition,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          mapController = controller;
        },
        onStyleLoadedCallback: () {
          mapController.addLine(
            LineOptions(
              geometry: polylineCoordinates,
              lineColor: "#FF0000", // Red color
              lineWidth: 3.0,
            ),
          );
        },
      ),
    );
  }
}

void downloadOfflineRegions() async {
  // Create the offline region definition
  final offlineRegionDefinition = OfflineRegionDefinition(
    bounds: LatLngBounds(
      southwest: const LatLng(-34.6503, 18.2324),
      northeast: const LatLng(-33.5992, 20.1664),
    ),
    minZoom: 10,
    maxZoom: 15,
    mapStyleUrl: "mapbox://styles/arazetdesign/clij33z5j00c201r17cdrejen",
  );

  // Create the offline region metadata

  // Create an offline region callback

  onEvent(DownloadRegionStatus status) {
    if (status.runtimeType == Success) {
      debugPrint("success");
    } else if (status.runtimeType == InProgress) {
      int progress = (status as InProgress).progress.round();
      debugPrint(progress.toString());
      // ...
    } else if (status.runtimeType == Error) {
      debugPrint(status.toString());
    }
  }

  downloadOfflineRegion(offlineRegionDefinition,
      metadata: {"name": "WesternCape"},
      accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
      onEvent: onEvent);
  return;
}
