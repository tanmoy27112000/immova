import 'package:flutter/material.dart';
import 'package:immova/screens/homePage.dart';
import 'package:overlay_support/overlay_support.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Circular',
        ),
        home: HomePage(),
      ),
    );
  }
}
