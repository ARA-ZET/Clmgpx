import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gpx/gpx.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late List<CameraDescription> cameras;
  late CameraController? _controller;
  Exif? exif;
  ExifLatLong? coordinates;
  Map<String, Object>? attributes;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameraList) {
      cameras = cameraList;
      _controller = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        ),
        ResolutionPreset.ultraHigh,
      );

      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  Future<void> capturePicture(nam, lat, lon) async {
    try {
      final path = join(
        (await getExternalStorageDirectory())!.path,
        ' $nam  ${DateTime.now()}.png',
      );
      debugPrint(path.toString());
      final name = await _controller!.takePicture();
      name.saveTo(path);
      exif = await Exif.fromPath(path);
      await exif!.writeAttributes({
        'GPSLatitude': lat.toString(),
        'GPSLongitude': lon.toString(),
        'UserComment':
            " Captured by Supervisor Richard:${lat.toString()} , ${lon.toString()}"
      });

      attributes = await exif!.getAttributes();
      debugPrint(attributes!.toString());
    } catch (e) {
      if (kDebugMode) {
        print('Failed to capture picture: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String iname = context.watch<FileController>().lastName;
    Wpt location = context.watch<LocationService>().currentLocation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CLM GPX CAMERA'),
      ),
      body: Column(
        children: [
          SizedBox(
              width: width,
              height: height * 0.6,
              child: _controller != null
                  ? CameraPreview(_controller!)
                  : Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                width: width * 0.6,
                height: 60,
                color: Colors.green,
                child: Text(
                  iname,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: width * 0.3,
                  height: 60,
                  color: Colors.red,
                  child: const Text('close'),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              capturePicture(iname, location.lat, location.lon).whenComplete(
                () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Saved $iname"),
                  ),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: width * 1,
              height: 60,
              child: const Text('Capture Picture'),
            ),
          ),
        ],
      ),
    );
  }
}
