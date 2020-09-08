import Flutter
import UIKit
import Openpay

public class SwiftOpenpayPlugin: NSObject, FlutterPlugin {
    
    var openpay : Openpay!
    
    var initialized : Bool = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "openpay_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftOpenpayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? Dictionary<String,Any>
        switch call.method {
        case "initialize":
            result(initialize(arguments!))
        case "getDeviceSessionId":
            getDeviceSessionId(result)
            break;
        case "createToken" :
            createToken(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func initialize(_ arguments: Dictionary<String,Any>) -> Bool{
        guard let merchantId = arguments["merchantId"] as? String else {
            return false
        }
        guard let apiKey = arguments["apiKey"] as? String else {
            return false
        }
        guard let productionMode = arguments["productionMode"] as? Bool else {
            return false
        }
        
        openpay = Openpay(withMerchantId: merchantId, andApiKey: apiKey, isProductionMode: productionMode)
        initialized = true
        return true
    }
    
    public func getDeviceSessionId(_ result: @escaping FlutterResult) {
        if(!initialized) {
            result(FlutterError(code: "NOT-INITIALIZED", message: "Openpay is not initialized, you need initialize OpenPay instance to use", details: nil))
            return
        }
        openpay.createDeviceSessionId(successFunction: {value in
            result(value)
        }, failureFunction:  { error in
            result("error_code: \(error.code)")
        })
    }
    
    public func createToken(_ result: @escaping FlutterResult){
        if(!initialized) {
            result(FlutterError(code: "NOT-INITIALIZED", message: "Openpay is not initialized, you need initialize OpenPay instance to use", details: nil))
            return
        }
        guard let uiViewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError(code: "UIViewController", message: "Can't get the UIViewController", details: nil))
            return
        }
        openpay.loadCardForm(in: uiViewController, successFunction: {
            self.openpay.createTokenWithCard(address: nil, successFunction: { (token) in
                result(token.id)
            }) { (error) in
                result(FlutterError(code: "CreateTokenError", message: "The token can't be created \(error.localizedDescription) -- \(error.code)", details: nil))
            }
        }, failureFunction: { (error) in
            result(FlutterError(code: "FormError", message: "Can't load the form", details: nil))
        }, formTitle: "Card creation")
    }
    
    
    
    
}
