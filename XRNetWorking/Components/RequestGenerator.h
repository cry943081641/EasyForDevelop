//
//  RequestGenerator.h
//  shengyin
//
//  Created by andy on 15/8/5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ServiceFactory.h"

@interface RequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier  RequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
@end
