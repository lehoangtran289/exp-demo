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

  bool _isProcessing = false;

  late String _msisdn;
  String? _config; //TODO

  bool _isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;
    final regExp = RegExp(r'^(84|0[3|5|7|8|9])+([0-9]{8})\b');
    return regExp.hasMatch(phoneNo);
  }

  void _handleSubmitted() async {
    setState(() {
      _isProcessing = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(_msisdn);
      prefs.setString("msisdn", _msisdn);
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'msisdn': _msisdn
      }); // TODO: pass config
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void initState() {
    setState(() {
      super.initState();
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
                  Image.asset('assets/viettelpay.png', height: 200,),
                  const SizedBox(height: 100,),
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
                    child: (_isProcessing
                        ? const SizedBox(
                            child: CircularProgressIndicator(color: Colors.white),
                            height: 20.0,
                            width: 20.0,
                          )
                        : const Text("Đăng nhập")),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(50, 15, 50, 15)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(color: Colors.red)
                        ))
                    ),
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
