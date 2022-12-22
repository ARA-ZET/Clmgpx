import 'package:flutter/material.dart';

class DoubleContainer extends StatelessWidget {
  final String text1;
  final String text2;

  const DoubleContainer({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            color: Colors.black,
            border: Border.all(
                width: 2, style: BorderStyle.solid, color: Colors.white),
          ),
          padding: EdgeInsets.only(right: width * 0.02),
          margin: EdgeInsets.all(width * 0.02),
          alignment: Alignment.centerLeft,
          width: width * 0.4,
          height: 36,
          child: Text(
            text1,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: Colors.black,
            border: Border.all(
                width: 2, style: BorderStyle.solid, color: Colors.white),
          ),
          padding: EdgeInsets.only(right: width * 0.02),
          margin: EdgeInsets.all(width * 0.02),
          alignment: Alignment.centerRight,
          width: width * 0.45,
          height: 36,
          child: Text(
            text2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
