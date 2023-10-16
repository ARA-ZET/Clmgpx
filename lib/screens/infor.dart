import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _AddWaypointState();
}

class _AddWaypointState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    String distance =
        "Distance: ${context.read<LocationService>().distance.toStringAsFixed(3)} Km";
    final timing = context.read<LocationService>().workingTime;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(timing.inHours.remainder(60));
    final minutes = twoDigits(timing.inMinutes.remainder(60));
    final seconds = twoDigits(timing.inSeconds.remainder(60));

    return AlertDialog(
      backgroundColor: Colors.black,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      scrollable: true,
      title: Column(
        children: [
          Text(distance),
          Container(
            height: 10,
          ),
          Text("Time : $hours : $minutes : $seconds")
        ],
      ),
      content: Container(
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(right: 6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.blueGrey,
            ),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 80,
            height: 50,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
