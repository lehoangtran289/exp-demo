import 'dart:developer';

import 'package:exp_demo/services/exp_config.dart';
import 'package:exp_demo/services/tracking_event.dart';
import 'package:exp_demo/models/user.dart';
import 'package:exp_demo/screens/components/stateless/popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  final User _user =
      User(name: "ViettelPay", balance: 100000, email: "viettelpay@digital.vn");
  bool _shouldPopUpBeShown = true;

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("msisdn");
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void showPopup() {
    print(data['msisdn']);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          color: const Color(0xFF737373),
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: DiscountInfo(_user.msisdn, data['event_value'])),
        );
      },
    );
  }

  void showDialog() async {
    await Future.delayed(const Duration(seconds: 2));
    showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: false,
        context: context,
        pageBuilder: (context, __, ___) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 450,
                child: Column(children: [
                  Expanded(
                    flex: 8,
                    child: TextButton(
                      child: Image.asset('assets/popup.png'),
                      onPressed: () {
                        // trackpoint
                        trackEvent('exp_popup', 'BUTTON', 'USER', 'CLICK', args: {
                          'identity': _user.msisdn,
                          'event_value': {
                            'version_exp': data['event_value']['version_exp']
                          }
                        });
                        showPopup();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        primary: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                        // trackpoint
                        trackEvent('exp_exit_popup', 'BUTTON', 'USER', 'CLICK', args: {
                          'identity': _user.msisdn,
                          'event_value': {
                            'version_exp': data['event_value']['version_exp']
                          }
                        });
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text(
                        'Đóng',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ]),
                margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    try {
      //CATCH config
      data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
      log('$data');
      if (_user.configs == null) {  // render first time
        _user.configs = handleExpConfig(data['configs']);
        log('here: ${_user.configs}');
        setState(() {
          _user.msisdn = data['msisdn'];
          _shouldPopUpBeShown = _user.configs!['Flag']; //TODO: rf hardcode for 'code' field of each exp config
        });
      }
      setState(() {
        _user.msisdn = data['msisdn'];
      });

    } catch (ex) {
      log('$ex');
      _user.msisdn = '';
    }

    // show popup
    if (_shouldPopUpBeShown) {
      showDialog();
      setState(() {
        _shouldPopUpBeShown = false;
      });
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
            _user.balance += 100000;
          });
          trackEvent('exp_add', 'BUTTON', 'USER', 'CLICK', args: {
            'identity': _user.msisdn,
            'event_value': {
              'version_exp': data['event_value']['version_exp']
            }
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
              const SizedBox(height: 50),
              Row(children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'MSISDN',
                    style: TextStyle(color: Colors.grey, letterSpacing: 1),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    _user.msisdn,
                    style: const TextStyle(
                        color: Colors.red,
                        letterSpacing: 1,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              const SizedBox(height: 30),
              Row(children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'TÊN TK',
                    style: TextStyle(color: Colors.grey, letterSpacing: 1),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    _user.name,
                    style: const TextStyle(
                        color: Colors.red,
                        letterSpacing: 1,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              const SizedBox(height: 30),
              Row(children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'SỐ DƯ',
                    style: TextStyle(color: Colors.grey, letterSpacing: 1),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Text(
                        NumberFormat.decimalPattern()
                            .format(_user.balance)
                            .toString(),
                        style: const TextStyle(
                            color: Colors.red,
                            letterSpacing: 1,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text('đ',
                          style: TextStyle(
                            color: Colors.grey,
                            letterSpacing: 1,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _user.email,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 16, letterSpacing: 0.5),
                  )
                ],
              ),
              const SizedBox(height: 30),
              // ElevatedButton(
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     primary: Colors.white,
              //     padding: const EdgeInsets.all(16.0),
              //     textStyle: const TextStyle(fontSize: 20),
              //     elevation: 0,
              //   ),
              //   onPressed: () {
              //     showPopup();
              //   },
              //   child: const Text(
              //     'Hiện popup',
              //     style: TextStyle(fontSize: 15),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
