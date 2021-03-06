//
//  PTWXManager.m
//  Plush
//
//  Created by aron on 2017/10/26.
//  Copyright © 2017年 qingot. All rights reserved.
//

#import "PTWXManager.h"
#import "PTWXRespManager.h"
#import "PTWXRequestHandler.h"
#import <WXApi.h>
#import "PTThirdPlatformManager.h"
#import "PTThirdPlatformObject.h"

@interface PTWXManager () <PTAbsThirdPlatformRespManagerDelegate>
@end


@implementation PTWXManager

DEF_SINGLETON

- (void)thirdPlatConfigWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //向微信注册
    NSString* appID = [[PTThirdPlatformManager sharedInstance] appIDWithPlaform:PTThirdPlatformTypeWechat];
    [WXApi registerApp:appID];
}

/**
 第三方平台处理URL
 */
- (BOOL)thirdPlatCanOpenUrlWithApplication:(UIApplication *)application
                                   openURL:(NSURL *)url
                         sourceApplication:(NSString *)sourceApplication
                                annotation:(id)annotation {
    // 微信
    if ([WXApi handleOpenURL:url delegate:[PTWXRespManager sharedInstance]]) {
        return YES;
    }
    return NO;
}

/**
 第三方登录
 */
- (void)signInWithType:(PTThirdPlatformType)thirdPlatformType fromViewController:(UIViewController *)viewController callback:(void (^)(ThirdPlatformUserInfo* userInfo, NSError* err))callback {
    self.callback = callback;
    [PTWXRespManager sharedInstance].delegate = self;
    [PTWXRequestHandler sendAuthInViewController:viewController];
}

// 分享
- (void)doShareWithModel:(ThirdPlatformShareModel *)model {
    self.shareResultBlock = model.shareResultBlock;
    [PTWXRespManager sharedInstance].delegate = self;
    BOOL shareResult = [PTWXRequestHandler sendMessageWithModel:model];
    if (shareResult == NO) {
        !self.shareResultBlock ?: self.shareResultBlock(PTShareTypeWechat, PTShareResultFailed, nil);
    }
}

/**
 第三方支付
 */
- (void)payWithPlateform:(PTThirdPlatformType)payMethodType order:(OrderModel*)order paymentBlock:(void (^)(PTPayResult result))paymentBlock {
    self.paymentBlock = paymentBlock;
    // 使用微信支付
    [PTWXRespManager sharedInstance].delegate = self;
    [PTWXRequestHandler payWithOrder:order];
}

- (BOOL)isThirdPlatformInstalled:(PTShareType)thirdPlatform {
    return [WXApi isWXAppInstalled];
}

@end
