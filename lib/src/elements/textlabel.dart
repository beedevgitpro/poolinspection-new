import 'package:flutter/material.dart';
import 'package:poolinspection/src/components/responsive_text.dart';

textLabel(String text,BuildContext context) {
  return Row(
    children: <Widget>[
      Text(text,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: "AVENIRLTSTD",
              fontSize: getFontSize(context,1),
              color: Color(0xff222222),
              fontWeight: FontWeight.w700)),
    ],
  );
}
