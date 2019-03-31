//
//  Service.m
//  shengyin
//
//  Created by andy on 15/8/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "Service.h"

@implementation Service

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(ServiceProtocal)]) {
            self.child = (id<ServiceProtocal>) self;
        }
    }
    return self;
}

- (NSString *)apiBaseUrl {
    return self.child.offlineApiBaseUrl;
}

@end
