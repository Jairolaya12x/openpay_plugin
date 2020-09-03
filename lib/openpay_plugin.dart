import 'dart:async';

import 'package:flutter/services.dart';
import 'package:openpay_plugin/models/credit_card.dart';

class OpenpayPlugin {
  static const MethodChannel _channel = const MethodChannel('openpay_plugin');

  ///Get a device session id.
  ///
  ///OpenPay can use the device information of a transaction in order to better detect fraudulent transactions.
  ///
  ///This method generates an identifier for the customer's device data. This value needs to be stored during checkout, and sent to OpenPay when processing the charge.
  static Future<String> get deviceSessionId async {
    final String _deviceSessionId =
        await _channel.invokeMethod('getDeviceSessionId');
    return _deviceSessionId;
  }

  ///Get a token from a credit card data.
  ///
  ///This method generates a token for the customer. This token is required for charges in the checkout.
  static Future<String> createToken(CreditCard creditCard) async {
    final String creditCardToken = await _channel
        .invokeMethod(
          'createToken',
          creditCard.toJson(),
        )
        .catchError(
          (error) => throw error,
        );
    return creditCardToken;
  }

  ///Initialize the OpenPay instance.
  ///
  /// **Note:**
  /// * Both [merchantId] as [apiKey], are obtained from the homepage of your account on the https://www.openpay.mx/ site.
  /// * You should never use your private key along with the library, because it is visible on the client side.
  static Future<void> initialize(String merchantId, String apiKey, bool productionMode) async {
    await _channel.invokeMethod('initialize', {
      'merchantId'      : merchantId,
      'apiKey'          : apiKey,
      'productionMode'  : productionMode
    });
  }
}
