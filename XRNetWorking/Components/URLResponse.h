//
//  URLResponse.h
//  shengyin
//
//  Created by andy on 15/8/5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XRNetWorkingConfiguration.h"

@interface URLResponse : NSObject
@property (nonatomic, assign) NSInteger statuCode;//保存 http 返回状态码，从而给出正确的提示信息
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData statuCode:(NSInteger)statuCode;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

@end
