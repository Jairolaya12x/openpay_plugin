package com.khimera.openpay_plugin

import android.app.Activity
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import mx.openpay.android.Openpay
import mx.openpay.android.OperationCallBack
import mx.openpay.android.OperationResult
import mx.openpay.android.exceptions.OpenpayServiceException
import mx.openpay.android.exceptions.ServiceUnavailableException
import mx.openpay.android.model.Card
import mx.openpay.android.model.Token


/** OpenpayPlugin */
public class OpenpayPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var openpay: Openpay

  private var activity : Activity? = null

  private var initialized : Boolean = false



  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "openpay_plugin")
    channel.setMethodCallHandler(this);
  }
  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "openpay_plugin")
      channel.setMethodCallHandler(OpenpayPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
      "initialize" -> {
        result.success(initialize(call))
      }

      "getDeviceSessionId" -> {
        val deviceSessionId = openpay.deviceCollectorDefaultImpl.setup(this.activity)
        result.success(deviceSessionId)
      }

      "createToken" -> {
        val _card : Card = Card();
        _card.holderName(call.argument("holder_name"))
        _card.cardNumber(call.argument("card_number"))
        _card.expirationMonth(call.argument("expiration_month"))
        _card.expirationYear(call.argument("expiration_year"))
        _card.cvv2(call.argument("cvv"))

        openpay.createToken(_card, object : OperationCallBack<Token> {

          override fun onSuccess(p0: OperationResult<Token>?) {
            result.success(p0!!.result.id)
          }

          override fun onError(p0: OpenpayServiceException?) {
            var _errorCode : String;
            var _errorDescription : String;
            when (p0!!.errorCode) {
              3001 -> {
                _errorCode = "3001 - DECLINED"
                _errorDescription = "The card was declined by the bank | La tarjeta fue declinada por el banco."
              }
              3002 -> {
                _errorCode = "3002 - EXPIRED"
                _errorDescription = "The card has expired | La tarjeta ha expirado."
              }
              3003 -> {
                _errorCode = "3003 - INSUFFICIENT FUNDS"
                _errorDescription = "The card doesn't have sufficient funds | La tarjeta no tiene fondos suficientes."
              }
              3004 -> {
                _errorCode = "3004 - STOLEN CARD"
                _errorDescription = "The card was reported as stolen | La tarjeta ha sido identificada como una tarjeta robada."
              }
              3005 -> {
                _errorCode = "3005 - SUSPECTED FRAUD"
                _errorDescription = "Fraud risk detected by anti-fraud system | La tarjeta ha sido rechazada por el sistema antifraude. \nFound in blacklist | Rechazada por coincidir con registros en lista negra."
              }
              else -> {
                _errorCode = "ERROR CODE: ${p0.errorCode.toString()}";
                _errorDescription = "An error has occurred, check the documentation for more details: https://www.openpay.mx/docs/errors.html"
              }
            }
            result.error(_errorCode, _errorDescription, null)
          }
          override fun onCommunicationError(p0: ServiceUnavailableException?) {
            result.error("COMMUNICATION ERROR", p0!!.message, null)
          }
        })
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    this.activity = null
    channel.setMethodCallHandler(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  private fun initialize(call: MethodCall) : Boolean {
    val merchantId : String = call.argument("merchantId")!!
    val apiKey : String = call.argument("apiKey")!!
    val productionMode : Boolean = call.argument("productionMode")!!
    this.openpay = Openpay(merchantId, apiKey, productionMode)
    this.initialized = true
    return true
  }
}
