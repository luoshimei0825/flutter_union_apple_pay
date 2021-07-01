//
//  FlutterUnionApplePayPlugin.m
//  FlutterUnionApplePayPlugin
//
//  Created by luoshimei on 2021/6/30.
//

#import "FlutterUnionApplePayPlugin.h"
#import "UPAPayPlugin.h"

#if __has_include(<flutter_union_apple_pay/flutter_union_apple_pay-Swift.h>)
#import <flutter_union_apple_pay/flutter_union_apple_pay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_union_apple_pay-Swift.h"
#endif

static NSString *methodChannelName = @"flutter_union_apple_pay";
static NSString *messageChannelName = @"flutter_union_apple_pay.message";

@interface FlutterUnionApplePayPlugin () <UPAPayPluginDelegate>
@end

@implementation FlutterUnionApplePayPlugin

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _viewController = viewController;
    }
    return self;
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:methodChannelName
                                                                      binaryMessenger:[registrar messenger]];
    messageChannel = [FlutterBasicMessageChannel messageChannelWithName:messageChannelName
                                                             binaryMessenger:[registrar messenger]
                                                                       codec:[FlutterStringCodec sharedInstance]];

    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterUnionApplePayPlugin *instance = [[FlutterUnionApplePayPlugin alloc] initWithViewController:viewController];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"pay" isEqualToString:call.method]) {
        [self pay:call result:result];
    } else if([@"version" isEqualToString:call.method]){
        [self getVersion:call result:result];
    }  else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)pay:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *tn = call.arguments[@"tn"];
    NSString *mode = call.arguments[@"mode"];
    NSString *merchantID = call.arguments[@"merchantID"];
    BOOL ret = [UPAPayPlugin startPay:tn
                                 mode:mode
                       viewController:self.viewController
                             delegate:self
                             andAPMechantID:merchantID];
    result([NSNumber numberWithBool:ret]);
}

- (void)getVersion:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *version = @"v0.0.1";
    result(version);
}

#pragma mark - UPAPayPluginDelegate

/**
 *  支付结果回调函数
 *
 *  @param payResult   以UPPayResult结构向商户返回支付结果
 */
- (void)UPAPayPluginResult:(UPPayResult *)payResult {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(payResult.paymentResultStatus == UPPaymentResultStatusSuccess) { // 支付成功
        NSString *otherInfo = payResult.otherInfo ? payResult.otherInfo : @"";
        [dict setValue:@(UPPaymentResultStatusSuccess) forKey:@"status"];
        [dict setValue:otherInfo forKey:@"message"];
    }
    else if(payResult.paymentResultStatus == UPPaymentResultStatusCancel) { // 支付取消
        NSString *otherInfo = payResult.otherInfo ? payResult.otherInfo : @"";
        [dict setValue:@(UPPaymentResultStatusCancel) forKey:@"status"];
        [dict setValue:otherInfo forKey:@"message"];
    }
    else if (payResult.paymentResultStatus == UPPaymentResultStatusFailure) { // 支付失败
        NSString *errorInfo = [NSString stringWithFormat:@"%@", payResult.errorDescription];
        [dict setValue:@(UPPaymentResultStatusFailure) forKey:@"status"];
        [dict setValue:errorInfo forKey:@"message"];
    }
    else if (payResult.paymentResultStatus == UPPaymentResultStatusUnknownCancel) { // 支付取消，交易已发起，状态不确定，商户需查询商户后台确认支付状态
        NSString *errorInfo = [NSString stringWithFormat:@"支付过程中用户取消了，请查询后台确认订单"];
        [dict setValue:@(UPPaymentResultStatusUnknownCancel) forKey:@"status"];
        [dict setValue:errorInfo forKey:@"message"];
    }

    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil];
    NSString *json = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
    [messageChannel sendMessage:json reply:^(id  _Nullable reply) {
        NSLog(@"reply:%@", reply);
    }];
}

@end
