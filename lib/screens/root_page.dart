import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:clmgpx/screens/distribution_mode.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:clmgpx/screens/acount.dart';
import 'package:clmgpx/screens/add_multiple_waypoints.dart';
import 'package:clmgpx/screens/add_waypoint.dart';
import 'package:clmgpx/screens/drive_up_loader_warning.dart';
import 'package:clmgpx/screens/drive_uploader.dart';

import 'package:clmgpx/screens/on_save.dart';
import 'package:clmgpx/screens/reset_warning.dart';
import 'package:clmgpx/screens/will_pop.dart';

import '../models/user_location.dart';
import '../widget/double_container.dart';
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
  Widget build(BuildContext context) {
    context.read<FileController>().readSession();
    context.read<FileController>().readSupportFiles();
    context.read<FileController>().startListening();
    context.read<FileController>().readCount();
    bool isRecording = context.watch<LocationService>().isRecordingg;

    double width = MediaQuery.of(context).size.width;

    String savedIdrive = context.watch<FileController>().lastSavedTrkDrive;
    String savedLocal = context.watch<FileController>().lastSavedTrkLocal;

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
          child: RepaintBoundary(
            child: AppBar(
              backgroundColor: Colors.blueGrey.shade900,
              foregroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TopBurnner(),
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
        ),
        body: Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.black),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //top buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900, // foreground
                        ),
                        onPressed: () => [
                          context
                              .read<FileController>()
                              .createFolder("Session"),
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
                    SizedBox(
                      width: width * 0.46,
                      child: ElevatedButton(
                        onPressed: () => [
                          isRecording = !isRecording,
                          isRecording
                              ? [
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .startTimer(resets: false),
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .startRecording(resets: false),
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .startWriteKml(resets: false),
                                ]
                              : [
                                  Provider.of<LocationService>(context,
                                          listen: false)
                                      .stopTimer(resets: false),
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

                // add waypoints button and location stats
                const BigButton(),
                // Below stats logic buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Multiple Button
                    Container(
                      width: width * 0.38,
                      height: 40,
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
                          'Enter Multiple',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),

                    // Save Button

                    Container(
                      width: width * 0.14,
                      height: 40,
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
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 38,
                          )),
                    ),

                    // Distribution mode

                    Container(
                      width: width * 0.14,
                      height: 36,
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const DistributionMode()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(0.8) // foreground
                            ),
                        child: const Icon(
                          Icons.map,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),

                    // Setting Button

                    Container(
                      width: width * 0.14,
                      height: 40,
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
                          Icons.share_location,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),

// Massage button

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: width * 0.55,
                      height: 36,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Hello !! Enjoy the day",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),

                    // Delete button

                    Container(
                      width: width * 0.15,
                      height: 40,
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
                            if (savedIdrive != savedLocal)
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopBurnner extends StatelessWidget {
  const TopBurnner({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        '${context.select((FileController controller) => controller.sessionData?.name ?? "arazetgpx")}  ${context.select((FileController controller) => controller.sessionData?.date ?? "no data")}  ${context.watch<FileController>().count}');
  }
}
// widget that contains distribution stats and add waypoint button

class BigButton extends StatelessWidget {
  const BigButton({super.key});

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Duration duration = context.watch<LocationService>().timecount;
    double distance = context.watch<LocationService>().distance;

    double averageSpeed = context.watch<LocationService>().avgSpeed;
    UserLocation userLocation = Provider.of<UserLocation>(context);

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    var speed = double.parse(userLocation.speed) * 3.6;
    var speedkmph = double.parse((speed).toStringAsFixed(2));
    return GestureDetector(
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
            }
          else
            {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const RepaintBoundary(child: AddWaypoint());
                },
              )
            },
        ];
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.only(bottom: 0),
        width: double.infinity,
        // color: Colors.black87,
        height: 344,
        decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: Colors.white70,
              width: 2,
            )),
        child: Column(
          children: [
            const Center(
              heightFactor: 1.2,
              child: Icon(
                color: Colors.white,
                Icons.add,
                size: 150,
              ),
            ),
            RepaintBoundary(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.all(width * 0.02),
                          alignment: Alignment.bottomLeft,
                          // width: width * 0.2,
                          height: 40,
                          child: Text(
                            userLocation.latitude,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: EdgeInsets.only(right: width * 0.02),
                          margin: EdgeInsets.all(width * 0.02),
                          alignment: Alignment.bottomRight,
                          // width: width * 0.6,
                          height: 40,
                          child: Text(
                            userLocation.longitude,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DoubleContainer(
                      text1: " Time  |  $hours:$minutes:$seconds",
                      text2: ' Distance  |  ${distance.toStringAsFixed(2)} km'),
                  DoubleContainer(
                      text1: " Speed |  ${speedkmph.toString()} Km/hr",
                      text2:
                          "Avg Spd | ${averageSpeed.toStringAsFixed(2)} Km/hr"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
