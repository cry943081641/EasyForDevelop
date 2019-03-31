//
//  AppContext.h
//  shengyin
//
//  Created by andy on 15/8/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContext : NSObject

@property (nonatomic, readonly) BOOL isReachable; // 网络是否可用

+ (instancetype)sharedInstance;
@end
