import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/file_controller.dart';

class SaveData extends StatefulWidget {
  const SaveData({super.key});

  @override
  State<SaveData> createState() => _SaveDataState();
}

class _SaveDataState extends State<SaveData> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _trackName = TextEditingController(
      text:
          'Track   ${context.watch<FileController>().sessionData?.date}   ${context.watch<FileController>().sessionData?.name}  ${context.watch<FileController>().sessionData?.client}  ${context.watch<FileController>().sessionData?.area}  ${context.watch<FileController>().count}');

  late final TextEditingController _wptName = TextEditingController(
      text:
          'Waypoints  ${context.watch<FileController>().sessionData?.date}   ${context.watch<FileController>().sessionData?.name}  ${context.watch<FileController>().sessionData?.client}  ${context.watch<FileController>().sessionData?.area}  ${context.watch<FileController>().count}');

  @override
  Widget build(BuildContext context) {
    final wpt = context.watch<FileController>().waypoints;
    final trk = context.watch<LocationService>().trackpoints;
    final dname =
        "${context.watch<FileController>().sessionData?.name}_${context.watch<FileController>().sessionData?.date}_Tracklog01 ";
    final lastSavedtrkDrive = context.read<FileController>().lastSavedTrkDrive;
    final lastSavedWptDrive = context.read<FileController>().lastSavedwptDrive;
    return AlertDialog(
      scrollable: true,
      title: const Text('Save Track & Waypoints'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: _wptName,
              ),
              TextFormField(
                  style: const TextStyle(fontSize: 14), controller: _trackName),
            ],
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => [
            context
                .read<FileController>()
                .writeText(wpt, '/Session/${_wptName.text}.gpx'),
            context
                .read<LocationService>()
                .writeTrack(dname, trk, '/Session/${_trackName.text}.gpx'),
            context.read<FileController>().writeSupportFiles(_trackName.text,
                _wptName.text, lastSavedtrkDrive, lastSavedWptDrive),
            Navigator.pop(context)
          ],
          child: SizedBox(
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.green,
              ),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 100,
              height: 40,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          child: GestureDetector(
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
              height: 40,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
