import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

Future<List<Map<String, dynamic>>> getEXPConfigs(
    {required String msisdn,
    int? limit,
    List<String>? expCode,
    required String productCode}) async {
  try {
    var response = await get(
        Uri.parse(
            'https://kpp.bankplus.vn/uatmm/exp/evaluator/public/v1/configs/users/$msisdn?limit=${limit ?? ''}&experiementCodes=${expCode ?? ""}&productCode=$productCode'),
        headers: {"Content-Type": "application/json"});
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']); // json to map
    log('get configs: $data');
    return data;
  } catch (ex) {
    log('caught error $ex');
    return [];
  }
}

Map handleExpConfig(var exps) {
  Map map = {};
  for(var exp in exps) {
    String expCode = exp['experimentCode'];
    switch(expCode) {
      case "VIETTELPAY-111021091001": {
        for (var config in exp['configs']) {
          if (config['code'] == 'Flag') {
            map['Flag'] = config['value'] == '1' ? true : false;
          }
        }
      }
      break;
      default: {} break;
    }
  }
  return map;
}
