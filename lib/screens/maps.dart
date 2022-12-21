// import 'package:clmgpx/screens/root_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class CurrentMap extends StatefulWidget {
//   const CurrentMap({super.key});

//   @override
//   State<CurrentMap> createState() => _CurrentMapState();
// }

// class _CurrentMapState extends State<CurrentMap> {
//   static const _inintialCameraPosition =
//       CameraPosition(target: LatLng(-33.916729, 18.509989), zoom: 11.5);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(30),
//         child: AppBar(
//           backgroundColor: Colors.blueGrey.shade900,
//           title: const Wcount(),
//         ),
//       ),
//       body: const GoogleMap(
//         myLocationButtonEnabled: false,
//         zoomControlsEnabled: false,
//         initialCameraPosition: _inintialCameraPosition,
//       ),
//     );
//   }
// }
