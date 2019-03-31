//
//  ServiceFactory.h
//  shengyin
//
//  Created by andy on 15/8/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface ServiceFactory : NSObject
+ (instancetype)sharedInstance;
- (Service<ServiceProtocal> *)serviceWithIdentifier:(NSString *)indetifier;
@end
