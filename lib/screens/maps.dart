import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:clmgpx/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpx/gpx.dart';
import 'package:provider/provider.dart';

class CurrentMap extends StatefulWidget {
  const CurrentMap({super.key});

  @override
  State<CurrentMap> createState() => _CurrentMapState();
}

class _CurrentMapState extends State<CurrentMap> {
  static const _inintialCameraPosition =
      CameraPosition(target: LatLng(-33.916729, 18.509989), zoom: 11.5);

  @override
  Widget build(BuildContext context) {
    final trk = context.watch<LocationService>().trackpoints;
    late List<LatLng> trkPoints =
        trk.map((wpt) => LatLng(wpt.lat!, wpt.lon!)).toList();

    late final points = context.watch<FileController>().pointList;
    Wpt currentLocation = context.watch<LocationService>().currentLocation;

    String iname = context.watch<FileController>().lastName;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.blueGrey.shade900,
          title: Column(
            children: [
              const Wcount(),
              Text(
                iname,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: {
              Polyline(
                  width: 6,
                  color: Colors.blue,
                  polylineId: const PolylineId('_kPolyline'),
                  points: trkPoints)
            },
            // polygons: polygons.map((polygon) {
            //   Color colorSelector(name) {
            //     if (name.toString() == "SEA POINT") {
            //       final fill = Colors.green;
            //       return fill;
            //     } else
            //       return Colors.red;
            //   }

            //   return Polygon(
            //     fillColor: colorSelector(polygon.name.toString()).withOpacity(0.2),
            //     strokeColor: colorSelector(polygon.name.toString()),
            //     strokeWidth: 2,
            //     polygonId: PolygonId(polygon.name),
            //     points: polygon.polygon.toList(),
            //     // onTap: () {
            //     //   fillColor: Colors.green
            //     // },
            //   );
            // }).toSet(),
            markers: points.map((point) {
              return Marker(
                  markerId: MarkerId(point.name),
                  position: point.pmarker,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  infoWindow: InfoWindow(title: point.name)
                  // onTap: () {
                  //   fillColor: Colors.green
                  // },
                  );
            }).toSet(),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _inintialCameraPosition,
          ),
          // const Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Row(
          //     children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(30)),
          //     color: Color.fromARGB(255, 33, 77, 84),
          //   ),
          //   margin: const EdgeInsets.all(6),
          //   alignment: Alignment.center,
          //   width: 75,
          //   height: 75,
          //   child: IconButton(
          //       iconSize: 60,
          //       onPressed: () {
          //         showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return const AddressedWaypoint();
          //           },
          //         );
          //       },
          //       icon: const Icon(
          //         Icons.add,
          //         color: Colors.white,
          //       )),
          // ),
          // Container(
          //   decoration: const BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(20)),
          //     color: Color.fromARGB(255, 19, 57, 13),
          //   ),
          //   margin: const EdgeInsets.all(10),
          //   alignment: Alignment.center,
          //   width: 75,
          //   height: 75,
          //   child: IconButton(
          //     iconSize: 50,
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return const CameraApp();
          //         },
          //       );
          //     },
          //     icon: const Icon(
          //       Icons.camera_alt_outlined,
          //       color: Colors.white,
          //     ),
          //   ),
          // )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
