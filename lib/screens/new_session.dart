import 'dart:async';

import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewSession extends StatefulWidget {
  const NewSession({super.key});

  @override
  State<NewSession> createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSession> {
  final _formKey = GlobalKey<FormState>();
  late final myName = TextEditingController(
      text: "${context.watch<FileController>().sessionData?.name}");
  final myDate = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(DateTime.now()));
  final myClient = TextEditingController();
  final myArea = TextEditingController();
  Timer? timer;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myName.dispose();
    myDate.dispose();
    myClient.dispose();
    myArea.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('New Session'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: RepaintBoundary(
            child: Column(
              children: [
                TextFormField(
                  controller: myName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name:',
                    icon: Icon(Icons.account_box),
                  ),
                ),
                TextFormField(
                  controller: myDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid date';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Date:',
                    icon: Icon(Icons.calendar_month),
                  ),
                ),
                TextFormField(
                  controller: myClient,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter client name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Client:',
                    icon: Icon(Icons.perm_contact_cal_outlined),
                  ),
                ),
                TextFormField(
                  controller: myArea,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter map id';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Map:',
                    icon: Icon(Icons.map_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              [
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New Session created')),
                ),
                Provider.of<LocationService>(context, listen: false)
                    .startTimer(resets: true),
                Provider.of<LocationService>(context, listen: false)
                    .startRecording(resets: false),
                context.read<FileController>().writesession(
                    myName.text, myDate.text, myClient.text, myArea.text),
                Navigator.pop(context),
              ];
            }
          },
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
                'Start',
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
