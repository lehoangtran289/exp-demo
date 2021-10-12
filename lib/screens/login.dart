
import 'dart:developer';

import 'package:exp_demo/common/utils.dart';
import 'package:exp_demo/services/exp_config.dart';
import 'package:exp_demo/services/tracking_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _msisdn;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void initState() {
    setState(() {
      super.initState();
      _isProcessing = false;
    });
  }

  void _handleSubmitted() async {
    setState(() {
      _isProcessing = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_formKey.currentState!.validate()) {
      log(_msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString("msisdn", _msisdn);

      // GET configs: note that a user could partake multiple exps
      List<Map<String, dynamic>> configs = await getEXPConfigs(msisdn: _msisdn, productCode: 'VIETTELPAY');

      List versionExps = configs.map((e) => e['versionCode']).toList();
      log('$versionExps');
      // List configs = response.map((e) => e['configs']).toList().expand((i) => i).toList();

      // FORWARD configs to /home
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'msisdn': _msisdn,
        'event_value': {
          'version_exp' : versionExps
        },
        'configs': configs
      });
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double viewInset = size.height - (size.height * 0.2);
    double defaultSize = size.height - (size.height * 0.2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/viettelpay.png', height: 200),
                  const SizedBox(height: 100),
                  Theme(
                    data: Theme.of(context).copyWith(primaryColor: Colors.red),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      textAlign: TextAlign.center,
                      cursorColor: Colors.red,
                      decoration: const InputDecoration(
                          labelText: "Nhập số điện thoại",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          labelStyle: TextStyle(color: Colors.grey)),
                      onChanged: (String? value) {
                        _msisdn = value!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty || !isPhoneNoValid(value)) {
                          return 'Số điện thoại không hợp lệ';
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      _handleSubmitted();
                      // trackpoint
                      trackEvent('exp_login', 'BUTTON', 'USER', 'CLICK', args: {
                        'identity': _msisdn,
                        'time_stamp': DateTime.now().millisecondsSinceEpoch
                      });
                    },
                    child: (_isProcessing
                        ? const SizedBox(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                            height: 20.0,
                            width: 20.0,
                          )
                        : const Text("Đăng nhập")),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(50, 15, 50, 15)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: Colors.red)))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
