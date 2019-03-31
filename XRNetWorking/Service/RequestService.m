//
//  RequestService.m
//  iReport
//
//  Created by cry on 2016/12/5.
//  Copyright © 2016年 foxhis. All rights reserved.
//

#import "RequestService.h"

@implementation RequestService

- (NSString *)offlineApiBaseUrl {
    NSString *ipAddr = [NSString stringWithFormat:@"%@%@:%@/%@" ,HTTPS, [USER_DEFAULTS valueForKey:kft_IP], [USER_DEFAULTS valueForKey:kft_PORT], KFT_PRONAME];
    return ipAddr;
}

//+ (NSString *)resourceApiBaseURL {
//    NSString *IPAddress;
//    if (![USER_DEFAULTS objectForKey:YDT_IP]) {
//        if ([USER_DEFAULTS objectForKey:YDT_PORT]) {
//            IPAddress = [NSString stringWithFormat:@"%@%@:%@/xopspring-portal", YDT_INTERNET_PROTOCOL, YDT_DEFAULT_DOMAIN, [USER_DEFAULTS objectForKey:YDT_PORT]];
//        } else {
//            IPAddress = [NSString stringWithFormat:@"%@%@:%@/xopspring-portal", YDT_INTERNET_PROTOCOL, YDT_DEFAULT_DOMAIN, YDT_DEFAULT_PORT];
//        }
//    } else {
//        if ([USER_DEFAULTS objectForKey:YDT_PORT]) {
//            IPAddress = [NSString stringWithFormat:@"%@%@:%@/xopspring-portal", YDT_INTERNET_PROTOCOL, [USER_DEFAULTS objectForKey:YDT_IP], [USER_DEFAULTS objectForKey:YDT_PORT]];
//        } else {
//            IPAddress = [NSString stringWithFormat:@"%@%@:%@/xopspring-portal", YDT_INTERNET_PROTOCOL, [USER_DEFAULTS objectForKey:YDT_IP], YDT_DEFAULT_PORT];
//        }
//    }
//    return IPAddress;
//}

@end
