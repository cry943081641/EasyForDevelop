//
//  RequestGenerator.m
//  shengyin
//  根据调用的方法生成request
//  Created by andy on 15/8/5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "RequestGenerator.h"
#import "NSURLRequest+AIFNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>

@interface RequestGenerator ()
@property (nonatomic,strong) AFJSONRequestSerializer *jsonRequestSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end


@implementation RequestGenerator
#pragma mark - getters and setters
- (AFJSONRequestSerializer *)jsonRequestSerializer {
    if (!_jsonRequestSerializer) {
        _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
        _jsonRequestSerializer.timeoutInterval = 60.0f;
        _jsonRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _jsonRequestSerializer;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = 60.0f;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

+ (instancetype)sharedInstance {
    static RequestGenerator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier  RequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    NSURLRequest *request = [self.jsonRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:nil];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:jsonString, @"data", nil];
    NSURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:params error:NULL];
    request.requestParams = requestParams;
    return request;
}



@end
