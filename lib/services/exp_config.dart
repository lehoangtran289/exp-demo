import 'dart:convert';
import 'package:http/http.dart';

Future<Map<String, dynamic>> _getEXPConfigs(String msisdn) async {
  try {
    var response = await get(Uri.parse('')); //TODO: add url
    Map<String, dynamic> data = jsonDecode(response.body); // json to map
    print('get configs: $data');
    return data;
  } catch (ex) {
    print('caught error $ex');
    return {};
  }
}