import 'package:clmgpx/screens/root_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clmgpx/providers/file_controller.dart';
import 'package:clmgpx/screens/add_waypoint.dart';

import 'acount.dart';
import 'new_session.dart';

class DistributionMode extends StatefulWidget {
  const DistributionMode({super.key});

  @override
  State<DistributionMode> createState() => _DistributionModeState();
}

class _DistributionModeState extends State<DistributionMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: RepaintBoundary(
          child: AppBar(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TopBurnner(),
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () => [
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const LoggedAccount();
                              },
                            ),
                          ],
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade900,
                          padding: const EdgeInsets.all(0.4)),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: GestureDetector(
          onTap: () {
            [
              if (Provider.of<FileController>(context, listen: false)
                      .sessionData
                      ?.name ==
                  'arazetgpx')
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const NewSession();
                    },
                  )
                }
              else
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const RepaintBoundary(child: AddWaypoint());
                    },
                  )
                },
            ];
          },
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(bottom: 0),
            width: double.infinity,
            // color: Colors.black87,
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black54,
                border: Border.all(
                  color: Colors.white70,
                  width: 2,
                )),
            child: const Center(
              heightFactor: 1.2,
              child: Icon(
                color: Colors.white,
                Icons.add,
                size: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
