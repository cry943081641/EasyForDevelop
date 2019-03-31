//
//  ApiProxy.h
//  shengyin
//
//  Created by Andy on 15/8/1.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "URLResponse.h"
#import "RequestGenerator.h"


typedef void(^RequestCallBack) (URLResponse *response);

@interface ApiProxy : NSObject

+ (instancetype)sharedInstance;

// 获取首页的文章信息
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)name success:(RequestCallBack)success fail:(RequestCallBack)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(RequestCallBack)success fail:(RequestCallBack)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestList;
@end
