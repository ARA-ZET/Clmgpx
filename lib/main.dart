import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:clmgpx/models/user_location.dart';
import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:clmgpx/screens/root_page.dart';
import 'package:clmgpx/services/file_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env");
  runApp(MultiProvider(
    providers: [
      StreamProvider(
        initialData: UserLocation("0.0", "0.0", "0.0", "0.0", "0.0", "0.0"),
        create: (_) => LocationService().locationStream,
      ),
      ChangeNotifierProvider(
        create: (_) => FileController(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationService(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initState() => [
        FileManager().createDir("/Session Data"),
        FileManager().createDir("/Session"),
        FileManager().writeJsonFile(
            "arazetgpx", "no data", "arazet design", "focus corner")
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColorDark: Colors.black,
          scaffoldBackgroundColor: Colors.black),
      home: const RootPage(),
    );
  }
}
