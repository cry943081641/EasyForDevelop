//
//  NSURLRequest+AIFNetworkingMethods.m
//  shengyin
//
//  Created by andy on 15/8/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "NSURLRequest+AIFNetworkingMethods.h"
#import <objc/runtime.h>

static void *AIFNetworkingRequestParams;

@implementation NSURLRequest (AIFNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, &AIFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams {
    return objc_getAssociatedObject(self, &AIFNetworkingRequestParams);
}
@end
