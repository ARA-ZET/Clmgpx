import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';
import 'package:provider/provider.dart';

class AddWaypoint extends StatefulWidget {
  const AddWaypoint({super.key});

  @override
  State<AddWaypoint> createState() => _AddWaypointState();
}

class _AddWaypointState extends State<AddWaypoint> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
      text: "Letterbox${context.watch<FileController>().count + 1}");

  @override
  Widget build(BuildContext context) {
    Wpt userLocation = context.watch<LocationService>().currentLocation;

    return AlertDialog(
      titleTextStyle: const TextStyle(color: Colors.white),
      scrollable: true,
      title: const Text('Add Letter Box'),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(2.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              enabled: false,
              controller: _name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'enter name';
                }
                return null;
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: 'Letterbox:',
              ),
            ),
          ]),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => [
            Navigator.pop(context),
            context.read<FileController>().icreament(
                userLocation.lat,
                userLocation.lon,
                userLocation.ele,
                _name.text,
                userLocation.time),
          ],
          child: Container(
            padding: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.green,
            ),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 100,
            height: 50,
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.blueGrey,
            ),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 100,
            height: 50,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        )
      ],
    );
  }
}
