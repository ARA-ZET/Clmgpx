import 'package:clmgpx/models/user_location.dart';
import 'package:clmgpx/providers/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddMultipleWaypoints extends StatefulWidget {
  const AddMultipleWaypoints({super.key});

  @override
  State<AddMultipleWaypoints> createState() => _AddMultipleWaypointsState();
}

class _AddMultipleWaypointsState extends State<AddMultipleWaypoints> {
  final _formKey = GlobalKey<FormState>();
  int boxes = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: _formKey,
      scrollable: true,
      title: const Text('Add Multiple waypoints'),
      content: const MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myDes = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    UserLocation userLocation = Provider.of<UserLocation>(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: myController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter number of boxes';
              }
              return null;
            },

            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],

            decoration: const InputDecoration(
              labelText: 'Enter number of boxes',
              icon: Icon(Icons.add_box_outlined),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: GestureDetector(
                  onTap: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      [
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Waypoints added')),
                        ),
                        context.read<FileController>().multi(
                            int.parse(myController.text),
                            UserLocation(
                              userLocation.latitude,
                              userLocation.longitude,
                              userLocation.altitude,
                              userLocation.speed,
                              userLocation.time,
                              userLocation.accuracy,
                            )),
                        Navigator.pop(context),
                      ];
                    }
                  },

                  // onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.green,
                    ),
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: width * 0.25,
                    height: 40,
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                // onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.only(right: 2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.blueGrey,
                  ),
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: width * 0.25,
                  height: 40,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
