import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteWarning extends StatefulWidget {
  const DeleteWarning({super.key});

  @override
  State<DeleteWarning> createState() => _DeleteWarningState();
}

class _DeleteWarningState extends State<DeleteWarning> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Warning'),
      content: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: const [
              Text("After reset all of distribution data is lost"),
              Text("-Reset tracklog                        "),
              Text("-Resert timer                            "),
              Text("-Distributor info                        "),
            ],
          )),
      actions: [
        GestureDetector(
          onTap: () => [
            Navigator.pop(context),
            context.read<FileController>().deleteData(),
            context.read<LocationService>().resetData(),
          ],
          child: SizedBox(
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.red,
              ),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 100,
              height: 40,
              child: const Text(
                'Reset',
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
