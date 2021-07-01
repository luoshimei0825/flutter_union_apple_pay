//
//  FlutterUnionApplePayPlugin.m
//  FlutterUnionApplePayPlugin
//
//  Created by luoshimei on 2021/6/30.
//

#import <Flutter/Flutter.h>

static FlutterBasicMessageChannel *messageChannel;

@interface FlutterUnionApplePayPlugin : NSObject<FlutterPlugin>
@property (nonatomic, strong) UIViewController *viewController;
@end
