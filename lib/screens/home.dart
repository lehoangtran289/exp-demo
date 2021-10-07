import 'package:exp_demo/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  User _user = User(name: "ViettelPay", balance: 10000, email: "viettelpay@digital.vn");

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void showPopup() {

  }

  @override
  Widget build(BuildContext context) {
    try {
      data = ModalRoute.of(context)!.settings.arguments as Map;
      print(data['msisdn']);
      _user.msisdn = data['msisdn'];
    } catch (ex) {
      print(ex);
      _user.msisdn = "";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('ViettelPay'),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _handleLogout();
              },
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _user.balance += 10000;
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
        elevation: 0,
        highlightElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/bannervtp.png'),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'MSISDN',
                style: TextStyle(color: Colors.grey, letterSpacing: 1),
              ),
              const SizedBox(height: 5),
              Text(
                _user.msisdn,
                style: const TextStyle(
                    color: Colors.red,
                    letterSpacing: 1,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                'NAME',
                style: TextStyle(color: Colors.grey, letterSpacing: 1),
              ),
              const SizedBox(height: 5),
              Text(
                _user.name,
                style: const TextStyle(
                    color: Colors.red,
                    letterSpacing: 1,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                'CURRENT BALANCE',
                style: TextStyle(color: Colors.grey, letterSpacing: 1),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('\$',
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 1,
                        fontSize: 28,
                      )),
                  Text(
                    _user.balance.toString(),
                    style: const TextStyle(
                        color: Colors.red,
                        letterSpacing: 1,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    _user.email,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 18, letterSpacing: 0.5),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
