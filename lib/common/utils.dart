import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<Map> getDeviceDetails() async {
  late String deviceName;
  late String deviceVersion;
  late String identifier;
  late String os;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model!;
      deviceVersion = Platform.operatingSystemVersion;
      identifier = build.androidId!; //UUID for Android
      os = "Android";
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name!;
      deviceVersion = data.systemVersion!;
      identifier = data.identifierForVendor!; //UUID for iOS
      os = "iOS";
    }
  } on PlatformException {
    print('Failed to get platform version');
  }
  return {
    'deviceName': deviceName,
    'deviceVersion': deviceVersion,
    'identifier': identifier,
    'os': os
  };
}

void trackEvent(String objName, String objType, String eventSrc, String action,
    {Map args = const {}}) async {
  Map deviceInfo = await getDeviceDetails();

  Map body = {
    ...{
      'action': action,
      'objectName': objName,
      'objectType': objType,
      'eventSrc': eventSrc,
      'os': deviceInfo['os'],
      'osVersion': deviceInfo['deviceVersion'],
    },
    ...args
  };

  print(body);

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var url = Uri.parse(
      'https://kpp.bankplus.vn/uatmm/exp/evaluator/public/v1/configs/log');
  var response =
      await http.post(url, body: jsonEncode(body), headers: requestHeaders);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}
