import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _msisdn;
  String? _config; //TODO

  bool _isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp =
        RegExp(r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
    return regExp.hasMatch(phoneNo);
  }

  void _handleSubmitted() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(_msisdn);
      prefs.setString("msisdn", _msisdn);
      Navigator.pushReplacementNamed(context, '/home',
          arguments: {'msisdn': _msisdn});
    }
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
                  Image.asset(
                    'assets/viettelpay.png',
                    height: 200,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(primaryColor: Colors.red),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          labelText: "Nhập số điện thoại",
                          fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      onChanged: (String? value) {
                        _msisdn = value!;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty || !_isPhoneNoValid(value)) {
                          return 'Số điện thoại không hợp lệ';
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      _handleSubmitted();
                    },
                    child: const Text("Đăng nhập"),
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