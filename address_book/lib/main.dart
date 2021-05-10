import 'package:flutter/material.dart';
import 'MainMenu.dart';
import 'Desain1.dart';
import 'Desain2.dart';
import 'MyHomePage.dart';
import 'DataResponden.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/mainmenu',
      routes: <String, WidgetBuilder>{
        '/mainmenu': (context) => MainMenu(),
        '/desain1': (context) => Desain1(),
        '/desain2': (context) => Desain2(),
        '/desaintest': (context) => MyApps(),
        '/data': (context) => DataResponden(),
      },
    );
  }
}