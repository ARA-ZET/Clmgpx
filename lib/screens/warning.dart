import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  final String warning;
  const Warning({super.key, required this.warning});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      scrollable: true,
      title: const Text(
        "        ERROR 404",
        style: TextStyle(color: Colors.red),
      ),
      content: Column(
        children: [
          Container(
            height: 8,
          ),
          Text(
            warning,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.all(2.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.only(right: 6),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.red,
                ),
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 80,
                height: 50,
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
