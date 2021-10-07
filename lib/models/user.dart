import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  late String msisdn;
  late String name;
  late num balance;
  late String email;
  late String configs;

  User(
      {required this.name,
      required this.balance,
      required this.email});
}
