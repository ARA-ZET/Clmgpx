import 'package:clmgpx/providers/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadProgress extends StatefulWidget {
  const UploadProgress({super.key});

  @override
  State<UploadProgress> createState() => _UploadProgressState();
}

class _UploadProgressState extends State<UploadProgress> {
  @override
  Widget build(BuildContext context) {
    int propress = context.watch<FileController>().progress;
    String uploading = context.watch<FileController>().uploading;
    Color color = context.watch<FileController>().color;

    return AlertDialog(
      alignment: Alignment.center,
      backgroundColor: Colors.black,
      scrollable: true,
      title: Text(
        "  $uploading",
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(75)),
                border: Border.all(color: color, width: 10),
              ),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 150,
              height: 150,
              child: Text(
                "${propress.toString()} %",
                style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: color,
              ),
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 120,
              height: 40,
              child: const Text(
                'DONE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
