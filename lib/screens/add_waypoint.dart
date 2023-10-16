import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_data.dart';

class AddWaypoint extends StatefulWidget {
  const AddWaypoint({super.key});

  @override
  State<AddWaypoint> createState() => _AddWaypointState();
}

class _AddWaypointState extends State<AddWaypoint> {
  @override
  Widget build(BuildContext context) {
    String name = "Letterbox${context.watch<LocationService>().count + 1}";

    return AlertDialog(
      backgroundColor: Colors.black,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      scrollable: true,
      title: Container(alignment: Alignment.center, child: Text(name)),
      content: Container(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => [
                context.read<LocationService>().increment(name),
                Navigator.pop(context),
              ],
              child: Container(
                padding: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.green,
                ),
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 200,
                height: 100,
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () => Navigator.pop(context),
            //   child: Container(
            //     padding: const EdgeInsets.only(right: 6),
            //     decoration: const BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(8)),
            //       color: Colors.blueGrey,
            //     ),
            //     margin: const EdgeInsets.all(10),
            //     alignment: Alignment.center,
            //     width: 80,
            //     height: 50,
            //     child: const Text(
            //       'Cancel',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 18,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
