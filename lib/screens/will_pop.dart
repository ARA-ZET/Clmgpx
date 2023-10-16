import 'package:flutter/material.dart';

class WillPop extends StatefulWidget {
  const WillPop({super.key});

  @override
  State<WillPop> createState() => _WillPopState();
}

class _WillPopState extends State<WillPop> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('WARING !!'),
      content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              "If you press Yes the app will stop recording and you might loose progress and if you want to continue CANCEL")),
      actions: [
        GestureDetector(
          onTap: () => [Navigator.of(context).pop(true)],
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
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: SizedBox(
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
