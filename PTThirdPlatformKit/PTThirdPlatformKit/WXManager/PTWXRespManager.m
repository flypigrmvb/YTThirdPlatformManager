//
//  PTWXRespManager.m
//  Plush
//
//  Created by aron on 2017/10/26.
//  Copyright © 2017年 qingot. All rights reserved.
//

#import "PTWXRespManager.h"
#import "WXApi.h"
#import "NSData+PTJsonConvert.h"
#import "PTThirdPlatformManager.h"
#import "NetworkRequestUtil.h"
#import "PTThirdPlatformObject.h"

@implementation PTWXRespManager

DEF_SINGLETON

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(respManagerDidRecvMessageResponse:platform:)]) {
            if (resp.errCode == WXSuccess) {
                [self.delegate respManagerDidRecvMessageResponse:YES platform:PTShareTypeWechat];
            } else {
                [self.delegate respManagerDidRecvMessageResponse:NO platform:PTShareTypeWechat];
            }
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess) {
            // wx请求accessToken & openId
            NSString* appID = [[PTThirdPlatformManager sharedInstance] appIDWithPlaform:PTThirdPlatformTypeWechat];
            NSString* appSecret = [[PTThirdPlatformManager sharedInstance] appSecretWithPlaform:PTThirdPlatformTypeWechat];
            NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", appID, appSecret, ((SendAuthResp*)resp).code];
            [NetworkRequestUtil requestWithURLString:urlString completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSDictionary *resultDict = [data nsjsonObject];
                [self getUserInfoWithAccessToken:[resultDict objectForKey:@"access_token"] andOpenId:[resultDict objectForKey:@"openid"]];
            }];
        } else {
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(respManagerDidRecvAuthResponse:platform:)]) {
                [self.delegate respManagerDidRecvAuthResponse:nil platform:PTThirdPlatformTypeWechat];
            }
        }
        
    } else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(respManagerDidRecvPayResponse:platform:)]) {
            PTPayResult payResult = resp.errCode == WXSuccess ? PTPayResultSuccess : resp.errCode == WXErrCodeUserCancel ? PTPayResultCancel : PTPayResultFailed ;
            [self.delegate respManagerDidRecvPayResponse:payResult platform:PTThirdPlatformTypeWechat];
        }
    }
}

//wx获取用户信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openId];
     [NetworkRequestUtil requestWithURLString:urlString completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *resultDict = [data nsjsonObject];
        ThirdPlatformUserInfo* userInfo = [ThirdPlatformUserInfo new];
        userInfo.userId = [resultDict objectForKey:@"unionid"];
        userInfo.openid = [resultDict objectForKey:@"openid"];
        userInfo.username = [resultDict objectForKey:@"nickname"];
        userInfo.head = [resultDict objectForKey:@"headimgurl"];
        userInfo.tokenString = accessToken;
        PTThirdPlatformOnMainThreadAsync(^{
            if (self.delegate
                && [self.delegate respondsToSelector:@selector(respManagerDidRecvAuthResponse:platform:)]) {
                [self.delegate respManagerDidRecvAuthResponse:userInfo platform:PTThirdPlatformTypeWechat];
            }
        });
    }];
}

@end
