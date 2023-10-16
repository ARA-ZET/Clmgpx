import 'package:flutter/material.dart';

class StatsLine extends StatelessWidget {
  const StatsLine({super.key, required this.text1, required this.text2});
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border:
            Border.all(width: 2, style: BorderStyle.solid, color: Colors.white),
      ),
      padding: EdgeInsets.all(width * 0.04),
      margin: EdgeInsets.all(width * 0.02),
      alignment: Alignment.centerLeft,
      width: width * 0.9,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            text2,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
