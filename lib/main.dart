import 'package:exp_demo/screens/home.dart';
import 'package:exp_demo/screens/loading.dart';
import 'package:exp_demo/screens/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
      },
      debugShowCheckedModeBanner: false,
    ));
