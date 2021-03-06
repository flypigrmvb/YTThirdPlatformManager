//
//  NetworkRequestUtil.m
//  YTThirdPlatformManager
//
//  Created by aron on 2017/10/28.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "NetworkRequestUtil.h"

@implementation NetworkRequestUtil

+ (void)requestWithURLString:(NSString*)urlString  completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    // 创建请求
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:20];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

@end
