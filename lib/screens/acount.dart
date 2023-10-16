import 'dart:async';

import 'package:clmgpx/providers/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoggedAccount extends StatefulWidget {
  const LoggedAccount({super.key});

  @override
  State<LoggedAccount> createState() => _LoggedAccountState();
}

class _LoggedAccountState extends State<LoggedAccount> {
  final _formKey = GlobalKey<FormState>();
  late final myName = TextEditingController(
      text: "${context.watch<FileController>().sessionData?.name}");
  final myDate = TextEditingController(
      text: DateFormat('dd MMM yyyy').format(DateTime.now()));
  late final myClient = TextEditingController(
      text: "${context.watch<FileController>().sessionData?.client}");
  late final myClientmap = TextEditingController(
      text: "${context.watch<FileController>().sessionData?.clientmap}");

  Timer? timer;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myName.dispose();
    myDate.dispose();
    myClient.dispose();
    myClientmap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FileController>().account;
    bool isLogged = context.watch<FileController>().isLogged;
    return AlertDialog(
      alignment: Alignment.topRight,
      scrollable: true,
      content: Container(
        width: 300,
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: isLogged
                        ? Image(
                            image: NetworkImage('${user!.photoUrl}'),
                          )
                        : const Image(
                            image: AssetImage("assets/arazetgpx.png"),
                            fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 4),
                child: isLogged
                    ? Text(
                        '${user!.displayName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        "Community Life",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              const Text(
                "Files are sent to your drive",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
              ),
              GestureDetector(
                onTap: () => [
                  isLogged = !isLogged,
                  isLogged
                      ? [context.read<FileController>().signInUser()]
                      : [context.read<FileController>().signOutUser()]
                ],
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.only(
                      right: 14, left: 14, top: 6, bottom: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 130,
                  child: isLogged
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.g_translate_rounded),
                            Text(
                              "Sign out",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.g_translate_rounded),
                            Text(
                              "Sign In",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                ),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
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
                style: const TextStyle(fontSize: 14),
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
                style: const TextStyle(fontSize: 14),
                controller: myClient,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid clientname';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Client:',
                  icon: Icon(Icons.person_2_outlined),
                ),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: myClientmap,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid map name';
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
      actions: [
        GestureDetector(
          onTap: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              [
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Distribution Data Updated')),
                ),
                context.read<FileController>().writesession(
                    myName.text, myDate.text, myClient.text, myClientmap.text),
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
                'Update',
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
