import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_union_apple_pay/enum/union_apple_pay_enum.dart';
import 'package:flutter_union_apple_pay/flutter_union_apple_pay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _result = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterUnionApplePay.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    FlutterUnionApplePay.listen((result) async {
      print('result status:${result.status}');
      print('result message:${result.message}');
      if (result.status == PaymentResultStatus.success) {
        setState(() {
          _result = 'success';
        });
      } else if (result.status == PaymentResultStatus.failure) {
        setState(() {
          _result = 'failure';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FlutterUnionApplePay.pay(
              tn: "826390196340300415210",  // TN流水单号有效期2个小时左右，过期后会没有反应或者显示系统错误
              mode: PaymentMode.product,    // TN对应的环境
              merchantID: "merchant.xxx", // 商户号
            ).then((value) {
              print("##########$value");
            });
          },
          child: Icon(Icons.payment),
        ),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text('Running on: $_platformVersion\n'),
              SizedBox(
                height: 50,
              ),
              Text('Payment result: $_result\n'),
            ],
          ),
        ),
      ),
    );
  }
}
