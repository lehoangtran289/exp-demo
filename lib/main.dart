import 'package:exp_demo/screens/home.dart';
import 'package:exp_demo/screens/loading.dart';
import 'package:exp_demo/screens/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
      },
      debugShowCheckedModeBanner: false,
    ));
