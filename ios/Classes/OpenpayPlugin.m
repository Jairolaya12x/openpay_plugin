#import "OpenpayPlugin.h"
#if __has_include(<openpay_plugin/openpay_plugin-Swift.h>)
#import <openpay_plugin/openpay_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "openpay_plugin-Swift.h"
#endif

@implementation OpenpayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpenpayPlugin registerWithRegistrar:registrar];
}
@end
