import 'package:clmgpx/providers/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriveUploader extends StatefulWidget {
  const DriveUploader({super.key});

  @override
  State<DriveUploader> createState() => _DriveUploaderState();
}

class _DriveUploaderState extends State<DriveUploader> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Warning'),
      content: const Padding(
          padding: EdgeInsets.all(2.0),
          child:
              Text("Last saved distribution data will be saved in your drive")),
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
