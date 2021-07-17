import 'package:flutter/material.dart';

const formDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  labelStyle: TextStyle(color: Colors.pink),
  prefixStyle: TextStyle(color: Colors.pink)
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide : BorderSide(color: Colors.white,width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide : BorderSide(color: Colors.pink,width: 2.0),
  ),
);

const textInputDecoration2 = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide : BorderSide(color: Colors.grey,width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide : BorderSide(color: Colors.pink,width: 2.0),
  ),
);