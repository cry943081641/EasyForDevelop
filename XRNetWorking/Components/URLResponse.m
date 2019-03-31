//
//  URLResponse.m
//  shengyin
//
//  Created by andy on 15/8/5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#import "NSURLRequest+AIFNetworkingMethods.h"
#import "URLResponse.h"

@interface URLResponse ()
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end



@implementation URLResponse

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData statuCode:(NSInteger)statuCode {
    self = [super init];
    if (self) {
        NSError *error = nil;
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &error];
        if (error != nil) {
            NSLog(@"初始化 response 的时候出错： %@", error);
        }
        self.statuCode = statuCode;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.isCache = NO;
    }
    return self;
}

// 出错时调用这个
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error {
    self = [super init];
    if (self) {
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
    }
    return self;
}
@end
