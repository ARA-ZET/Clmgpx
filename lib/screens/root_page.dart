import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:clmgpx/screens/infor.dart';
import 'package:clmgpx/screens/mapbox_map.dart';
import 'package:clmgpx/screens/maps.dart';
import 'package:clmgpx/screens/warning.dart';
import 'package:clmgpx/services/offline_region.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:clmgpx/screens/acount.dart';
import 'package:clmgpx/screens/add_multiple_waypoints.dart';
import 'package:clmgpx/screens/add_waypoint.dart';
import 'package:clmgpx/screens/on_save.dart';
import 'package:clmgpx/screens/reset_warning.dart';
import 'package:clmgpx/screens/will_pop.dart';
import '../models/saved_data.dart';
import 'drive_up_loader_warning.dart';
import 'drive_uploader.dart';
import 'new_session.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  Timer? timer;

  @override
  List initState() {
    super.initState();
    return [
      //run this providers when restart app to read previous session data
      context.read<FileController>().readSession(),
      context.read<LocationService>().readGpx("/Session Data/backupwpt.gpx"),
      context.read<LocationService>().readGpxTrk("/Session Data/backuptrk.gpx"),
      context.read<LocationService>().readCount(),
      context.read<FileController>().readSupportFiles(),
      // context.read<FileController>().kmlreader(),
      // context.read<FileController>().kmlPoints(),
      // context.read<FileController>().pointsNames(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording = context.watch<LocationService>().isRecording;
    bool isConnected = context.watch<LocationService>().isConnected;
    SavedData? saved = context.watch<FileController>().savedData;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

//on will pop prevents unintended press of back button
    Future<bool> onWillPop() async {
      return (await showDialog(
              context: context,
              builder: (BuildContext context) {
                return const WillPop();
              })) ??
          false;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AppBar(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Wcount()),
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () => [
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const LoggedAccount();
                              },
                            ),
                          ],
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade900,
                          padding: const EdgeInsets.all(0.4)),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          width: width * 1,
          height: height * 1,
          decoration: const BoxDecoration(color: Colors.black),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // New session burton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.46,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900, // foreground
                        ),
                        onPressed: () => [
                          context
                              .read<FileController>()
                              .createFolder("Session"),
                          context.read<FileController>().createFolder("Backup"),
                          context
                              .read<FileController>()
                              .createFolder("Session Data"),
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const NewSession();
                            },
                          )
                        ],
                        child: const Text(
                          'New Session',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    // Recotrd or pause button
                    SizedBox(
                      width: width * 0.46,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => [
                          isRecording = !isRecording,
                          isRecording
                              ? [
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .startRecording(resets: false),
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .startWriteGpx(resets: false),
                                ]
                              : [
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .stopRecording(resets: false),
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .stopWriteKml(resets: false),
                                ]
                        ],
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isRecording ? Colors.green : Colors.red),
                        child: isRecording
                            ? const Text(
                                'Recording...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              )
                            : const Text(
                                'Paused !!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                // add waypoints button
                GestureDetector(
                  onTap: () {
                    [
                      if (Provider.of<FileController>(context, listen: false)
                              .sessionData
                              ?.name ==
                          'arazetgpx')
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const NewSession();
                            },
                          )
                        },
                      if (isRecording == false)
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Warning(
                                  warning:
                                      "Resume track recording to add more waypoints");
                            },
                          )
                        }
                      else
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddWaypoint();
                            },
                          )
                        },
                    ];
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.only(bottom: 0),
                    height: 344,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                          width: 2,
                        ),
                        color: isConnected ? Colors.black : Colors.red),
                    child: const Center(
                      heightFactor: 1.2,
                      child: Icon(
                        color: Colors.white,
                        Icons.add,
                        size: 150,
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Multiple letterboxes Button
                    Container(
                      width: width * 0.38,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.black),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // foreground
                        ),
                        onPressed: () {
                          if (Provider.of<FileController>(context,
                                      listen: false)
                                  .sessionData
                                  ?.name ==
                              'arazetgpx') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const NewSession();
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AddMultipleWaypoints();
                              },
                            );
                          }
                        },
                        child: const Text(
                          'Multiple Boxes',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),

                    // Save Button
                    Container(
                      width: width * 0.18,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const SaveData();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.all(0.8) // foreground
                              ),
                          child: const Text(
                            "SAVE",
                          )),
                    ),

                    // distribution info Button
                    Container(
                      width: width * 0.14,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<LocationService>(context, listen: false)
                              .distanceCal();
                          // Provider.of<LocationService>(context, listen: false)
                          //     .timming(1);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Info();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(0.8) // foreground
                            ),
                        child: const Icon(
                          Icons.directions_walk_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    // Location Settings Button
                    Container(
                      width: width * 0.14,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: AppSettings.openLocationSettings,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.8),
                            backgroundColor: Colors.black // foreground
                            ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),

                // Gps Status button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: width * 0.55,
                      height: 36,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: TextButton(
                        style: isConnected
                            ? TextButton.styleFrom(
                                backgroundColor: Colors.green)
                            : TextButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {},
                        child: isConnected
                            ? const Text(
                                'Connected',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              )
                            : const Text(
                                'No Gpx Fix',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),

                    // Delete session data button
                    Container(
                      width: width * 0.15,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const DeleteWarning();
                            },
                          );
                        },
                        child: Container(
                            width: width * 0.15,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete_sweep_sharp,
                              color: Colors.white,
                              size: 36,
                            )),
                      ),
                    ),

                    // Drive upload button
                    Container(
                      width: width * 0.15,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          [
                            if (saved?.driveTrk != saved?.localTrk)
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const DriveUploader();
                                  },
                                )
                              }
                            else
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const DriveUploaderWarning();
                                  },
                                )
                              },
                          ];
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(0.4) // foreground
                            ),
                        child: const Icon(
                          Icons.drive_file_move,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Progress google Map
                    Container(
                      width: width * 0.14,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CurrentMap();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(0.8) // foreground
                            ),
                        child: const Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    // Progress mapbox
                    Container(
                      width: width * 0.18,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return const Mapboxmaps();
                          //   },
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(0.8) // foreground
                            ),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    // Not Used
                    Container(
                      width: width * 0.14,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return const OfflineRegionBody();
                          //   },
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(0.8) // foreground
                            ),
                        child: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    // Not used
                    Container(
                      width: width * 0.14,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.white),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0.8),
                            backgroundColor: Colors.black // foreground
                            ),
                        child: const Icon(
                          Icons.info_outline_sharp,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Topbar
class Wcount extends StatelessWidget {
  const Wcount({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        '${context.watch<FileController>().sessionData?.name}  ${context.watch<FileController>().sessionData?.date}  ${context.watch<LocationService>().count}');
  }
}
