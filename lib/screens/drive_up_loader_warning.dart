import 'package:clmgpx/providers/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriveUploaderWarning extends StatefulWidget {
  const DriveUploaderWarning({super.key});

  @override
  State<DriveUploaderWarning> createState() => _DriveUploaderWarningState();
}

class _DriveUploaderWarningState extends State<DriveUploaderWarning> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Warning'),
      content: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
              "File already saved in drive...  Press Upload to upload anyway or Cancel to abort   ")),
      actions: [
        GestureDetector(
          onTap: () => [
            Navigator.pop(context),
            context.read<FileController>().driveFile(),
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
                'Upload',
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
