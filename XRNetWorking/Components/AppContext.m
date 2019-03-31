//
//  AppContext.m
//  shengyin
//
//  Created by andy on 15/8/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AppContext.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation AppContext


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static AppContext *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppContext alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}
@end
