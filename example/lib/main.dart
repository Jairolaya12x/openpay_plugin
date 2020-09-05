import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpay_plugin/models/credit_card.dart';
import 'package:openpay_plugin/openpay_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  String _deviceSessionId = 'Unknown';

  String _creditCardToken = 'Unknown';

  bool _openPayInitialized = false;


  final textEditingController = TextEditingController();
  final textEditingControllerCard = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getDeviceId() async {
    String deviceId;

    try {
      deviceId = await OpenpayPlugin.deviceSessionId.catchError((error) => print(error));
    } on PlatformException {
      return 'Failed to get the device session id';
    }

    setState(() {
      textEditingController.text = deviceId;
      _deviceSessionId = deviceId;
    });
  }

  Future<bool> initialize() async {
    try {
      await OpenpayPlugin.initialize("mefqzcuuaggtdn6cq4jh", "pk_2f732686521c48c8a81aec2b2868b001", false);
      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> createToken() async {
    String _token;
    final _creditCard = CreditCard('Jairo Olaya', '4111111111111111', 12, 21, '123');
    _token = await OpenpayPlugin.createToken(_creditCard).catchError((error) => throw error);
    setState(() {
      textEditingControllerCard.text = _token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Openpay plugin test!'),
        ),
        body: Column(
          children: [
            SizedBox(height: 20,),
            RaisedButton.icon(
              onPressed: () async {
                  _openPayInitialized = await initialize();
                  setState(() {
                    
                  });
              },
              icon: Icon(Icons.phone_android),
              label: Text('Initialize OpenPay'),
            ),
            Text("OpenPay Status: ${_openPayInitialized.toString()}"),
            Divider(),
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            RaisedButton.icon(
              onPressed: () => getDeviceId(),
              icon: Icon(Icons.phone_android),
              label: Text('Get device id'),
            ),
            TextField(
              controller: textEditingController,
            ),
            RaisedButton.icon(
              onPressed: () => createToken(),
              icon: Icon(Icons.credit_card),
              label: Text('Get card token'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: textEditingControllerCard,
            ),
          ],
        ),
      ),
    );
  }
}
