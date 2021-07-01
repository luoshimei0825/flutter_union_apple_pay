import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'enum/union_apple_pay_enum.dart';
import 'model/payment_result_model.dart';

class FlutterUnionApplePay {
  static const _METHOD_CHANNEL_NAME = 'flutter_union_apple_pay';
  static const _MESSAGE_CHANNEL_NAME = 'flutter_union_apple_pay.message';

  static const MethodChannel _channel = const MethodChannel(_METHOD_CHANNEL_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('version');
    return version;
  }


  /// 支付
  /// @param tn 订单号
  /// @param mode 环境
  /// @param merchantID 商户号【注意格式是；merchant.xxx】
  static Future<bool> pay({
    @required String tn,
    @required PaymentMode mode,
    @required String merchantID,
  }) async {
    return await _channel.invokeMethod('pay', {
      'tn': tn,
      'mode': _getModeString(mode),
      'merchantID': merchantID,
    });
  }

  /// 监听支付状态
  static void listen(Function(PaymentResult result) onListener) {
    var channel = BasicMessageChannel(_MESSAGE_CHANNEL_NAME, StringCodec());
    channel.setMessageHandler((message) => onListener(PaymentResult.fromJson(message)));
  }

  static String _getModeString(PaymentMode mode) {
    switch (mode) {
      case PaymentMode.product:
        return "00";
        break;
      case PaymentMode.development:
        return "01";
        break;
    }
    return "00";
  }

}
