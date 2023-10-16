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
  @override
  Widget build(BuildContext context) {
    final wpt = context.watch<LocationService>().waypoints;
    final trk = context.watch<LocationService>().trackpoints;
    final sessionInfo = context.watch<FileController>().sessionData;
    final count = context.watch<LocationService>().count;
    final String file =
        "${sessionInfo?.date}   ${sessionInfo?.name}   ${sessionInfo?.client}   ${sessionInfo?.clientmap}   $count";

    final dname = "${sessionInfo?.name}_${sessionInfo?.date}_Tracklog01 ";

    final savedData = context.read<FileController>().savedData;

    return AlertDialog(
      backgroundColor: Colors.black,
      scrollable: true,
      title: const Text(
        'Save Track & Waypoints',
        style: TextStyle(color: Colors.white),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Track  $file", style: const TextStyle(color: Colors.white)),
            const Text(
              "Last saved:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            Text(savedData!.localTrk,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => [
            context
                .read<LocationService>()
                .writeWpts(wpt, '/Session/Waypoints  $file.gpx'),
            context
                .read<LocationService>()
                .writeTrack(dname, trk, '/Session/Track  $file.gpx'),
            context.read<FileController>().writeSupportFiles('Track  $file.gpx',
                'Waypoints  $file.gpx', savedData.driveTrk, savedData.driveWpt),
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
