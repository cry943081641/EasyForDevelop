//
//  Service.h
//  shengyin
//
//  Created by andy on 15/8/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceProtocal
@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@end

@interface Service : NSObject
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, weak) id<ServiceProtocal> child;
@end
