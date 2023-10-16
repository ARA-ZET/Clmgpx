import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/providers/location_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressedWaypoint extends StatefulWidget {
  const AddressedWaypoint({super.key});

  @override
  State<AddressedWaypoint> createState() => _AddressedWaypointState();
}

class _AddressedWaypointState extends State<AddressedWaypoint> {
  final _formKey = GlobalKey<FormState>();
  late final myName = TextEditingController();

  late final List<String> _options =
      Provider.of<FileController>(context, listen: false).nameList;

  @override
  void dispose() {
    myName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Add Delivery Point'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: RepaintBoundary(
            child: Column(
              children: [
                RawAutocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return _options.where((String option) {
                      return option.contains(textEditingValue.text);
                    });
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController myName,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextFormField(
                      controller: myName,
                      textCapitalization: TextCapitalization.words,
                      focusNode: focusNode,
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter point name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Address:',
                        icon: Icon(Icons.location_city_rounded),
                      ),
                    );
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          height: 200.0,
                          width: 250,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                  myName.text = option;
                                },
                                child: ListTile(
                                  title: Text(option),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
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
                  const SnackBar(content: Text('Delivery Address Added')),
                ),
                Provider.of<FileController>(context, listen: false)
                    .updateName(myName.text),
                context.read<LocationService>().increment(myName.text),
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
                'Add',
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
