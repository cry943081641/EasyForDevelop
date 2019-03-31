//
//  ApiProxy.m
//  shengyin
//
//  Created by Andy on 15/8/1.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ApiProxy.h"


@interface ApiProxy ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) AFHTTPSessionManager *operationManager;
@end

@implementation ApiProxy

#pragma -mark getters and setters
- (AFHTTPSessionManager *)operationManager {
    if (!_operationManager) {
        _operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_operationManager.requestSerializer setTimeoutInterval:60];
    }
    return _operationManager;
}

- (NSMutableDictionary *)dispatchTable {
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ApiProxy alloc] init];
    });
    return sharedInstance;
}

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(RequestCallBack)success fail:(RequestCallBack)fail {
    NSURLRequest *request = [[RequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier  RequestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(RequestCallBack)success fail:(RequestCallBack)fail {
    NSURLRequest *request = [[RequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

#pragma mark - private methods
// 对请求组件包装 同时生成requestId
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(RequestCallBack)success fail:(RequestCallBack)fail {
    __block NSURLSessionDataTask *sessionTask = nil;
    sessionTask = [self.operationManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * response, id  responseObject, NSError * error) {
        NSNumber *requestId = @([sessionTask taskIdentifier]);//如果是同一个任务，那么就从列表中移除
        [self.dispatchTable removeObjectForKey:requestId];
        
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        if (response == nil || error) {//请求失败
            URLResponse *errorResponse = [[URLResponse alloc] initWithResponseString:responseObject requestId:requestId request:request responseData:responseObject error:error];
            errorResponse.statuCode = httpURLResponse.statusCode;
            fail ? fail(errorResponse) : nil;
        } else {//请求成功
            NSData *responseData = responseObject;
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            URLResponse *successResponse = [[URLResponse alloc] initWithResponseString:responseString requestId:requestId request:request responseData:responseObject statuCode:httpURLResponse.statusCode];
            success ? success(successResponse) : nil;
        }
    }];
    
    NSNumber *requestId = @([sessionTask taskIdentifier]);

    self.dispatchTable[requestId] = sessionTask;
    [sessionTask resume];
    return requestId;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSOperation *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestList {
    for (NSNumber *requestId in requestList) {
        [self cancelRequestWithRequestID:requestId];
    }
}


@end
