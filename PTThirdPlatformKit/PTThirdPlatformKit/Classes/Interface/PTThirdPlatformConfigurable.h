//
//  PTThirdPlatformConfigurable.h
//  Pods
//
//  Created by aron on 2017/11/13.
//
//

#import <Foundation/Foundation.h>
#import "PTThirdPlatformDefine.h"

@protocol PTThirdPlatformConfigurable <NSObject>

/**
 *  按需设置平台的appkey/appID/appSecret/redirectURL/URLSchemes
 *
 *  @param platformType 平台类型 @see PTThirdPlatformType
 *  @param appKey       第三方平台的appKey
 *  @param appID        第三方平台的appID
 *  @param appSecret    第三方平台的appSecret
 *  @param redirectURL  redirectURL
 *  @param URLSchemes   URLSchemes，目前支付宝使用到，调用支付宝的时候需要传递一个URLSchemes参数
 */
- (BOOL)setPlaform:(PTThirdPlatformType)platformType
             appID:(NSString *)appID
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL
        URLSchemes:(NSString*)URLSchemes;

/**
 *  按需设置平台的appkey/appID/appSecret/redirectURL/URLSchemes
 *  一个平台不同的功能对应不用的配置使用该方法配置
 *
 *  @param platformType 平台类型 @see PTThirdPlatformType
 *  @param appKey       第三方平台的appKey
 *  @param appID        第三方平台的appID
 *  @param appSecret    第三方平台的appSecret
 *  @param redirectURL  redirectURL
 *  @param URLSchemes   URLSchemes，目前支付宝使用到，调用支付宝的时候需要传递一个URLSchemes参数
 */
- (BOOL)setPlaform:(PTThirdPlatformType)platformType
           subType:(PTThirdPlatformSubType)subType
             appID:(NSString *)appID
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL
        URLSchemes:(NSString*)URLSchemes;

- (NSString*)appIDWithPlaform:(PTThirdPlatformType)platformType;
- (NSString*)appKeyWithPlaform:(PTThirdPlatformType)platformType;
- (NSString*)appSecretWithPlaform:(PTThirdPlatformType)platformType;
- (NSString*)appRedirectURLWithPlaform:(PTThirdPlatformType)platformType;
- (NSString*)URLSchemesWithPlaform:(PTThirdPlatformType)platformType;

- (NSString*)appIDWithPlaform:(PTThirdPlatformType)platformType subType:(PTThirdPlatformSubType)subType;
- (NSString*)appKeyWithPlaform:(PTThirdPlatformType)platformType subType:(PTThirdPlatformSubType)subType;
- (NSString*)appSecretWithPlaform:(PTThirdPlatformType)platformType subType:(PTThirdPlatformSubType)subType;
- (NSString*)appRedirectURLWithPlaform:(PTThirdPlatformType)platformType subType:(PTThirdPlatformSubType)subType;
- (NSString*)URLSchemesWithPlaform:(PTThirdPlatformType)platformType subType:(PTThirdPlatformSubType)subType;

/**
 插件接入点-添加登录或者是支付的管理类

 @param platformType 自定义的第三方平台类型，大于999
 @param managerClass 实现了PTAbsThirdPlatformManager接口的自定义第三方平台管理类
 */
- (void)addCustomPlatform:(NSInteger)platformType managerClass:(Class)managerClass;

/**
 插件接入点-添加分享的管理类

 @param sharePlatformType 自定义的第三方平台分享类型，大于999
 @param managerClass 实现了PTAbsThirdPlatformManager接口的自定义第三方平台管理类
 */
- (void)addCustomSharePlatform:(NSInteger)sharePlatformType managerClass:(Class)managerClass;

@end
