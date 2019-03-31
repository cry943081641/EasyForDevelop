//
//  GeneralAPIManager.m
//  iReport
//
//  Created by Cry on 2017/10/25.
//  Copyright © 2017年 foxhis. All rights reserved.
//

#import "GeneralAPIManager.h"
#import "AppContext.h"
#import "XRNetWorking.h"

@interface GeneralAPIManager()
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic) NSString *errorMessage;//这个属性对外只读，对内可以修改
@property (nonatomic) GeneralAPIRequestErrorType errorType;//这个属性对外只读，对内可以修改
@property (nonatomic, strong) NSMutableArray *requestIdList;
@end

@implementation GeneralAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _errorMessage = @"获取失败,请检查网络及其配置。";
    }
    return self;
}

- (void)cancelAllRequests {
    [[ApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [self removeRequestIDWithRequestID:requestID];
    [[ApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

//发起请求
- (NSInteger)loadData {
    NSDictionary *params = [self.dataSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    
    if ([self isReachable]) {
        if ([self isCorrectWithParamsData:params]) {
            switch (self.requestType) {
                case GeneralAPIRequestRequestTypePOST:
                {
                    requestId = [[ApiProxy sharedInstance] callPOSTWithParams:params serviceIdentifier:self.serviceType methodName:self.methodName success:^(URLResponse *response) {
                        [self successedOnCallingAPI:response];
                    } fail:^(URLResponse *response) {
                        [self failedOnCallingAPI:response withErrorType:[self responseStatuInResponse:response]];
                    }];
                    break;
                }
                case GeneralAPIRequestRequestTypeGET:
                {
                    requestId = [[ApiProxy sharedInstance] callGETWithParams:params serviceIdentifier:self.serviceType methodName:self.methodName success:^(URLResponse *response) {
                        [self successedOnCallingAPI:response];
                    } fail:^(URLResponse *response) {
                        [self failedOnCallingAPI:response withErrorType:[self responseStatuInResponse:response]];
                    }];
                    break;
                }
                default:
                    break;
            }
            return requestId;
        } else {
            [self failedOnCallingAPI:nil withErrorType:GeneralAPIRequestErrorTypeParamsError];//给的参数不对
            return requestId;
        }
    } else {
        [self failedOnCallingAPI:nil withErrorType:GeneralAPIRequestErrorTypeNoNetWork];//没有网络
        return requestId;
    }
    return requestId;
}

#pragma mark ---私有方法
- (void)removeRequestIDWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDRemove = storedRequestId;
        }
    }
    if (requestIDRemove) {
        [self.requestIdList removeObject:requestIDRemove];
    }
}

- (void)successedOnCallingAPI:(URLResponse *)response {
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIDWithRequestID:response.requestId];
    
    if (response.content == nil) {
        [self failedOnCallingAPI:response withErrorType:GeneralAPIRequestErrorTypeSessionExired];
    } else if (![self isCorrectWithCallBackData:response.content]) {//格式不正确
        [self failedOnCallingAPI:response withErrorType:GeneralAPIRequestErrorTypeResponseFormatUncorrect];
    } else if ([response.content[@"success"] isEqualToString:@"false"] && response.content[@"message"]) {//有错误信息返回
        [self failedOnCallingAPI:response withErrorType:GeneralAPIRequestErrorTypeErrorMessage];
    } else {
        [self.delegate managerCallApiDidSuccess:self];
    }
}

- (void)failedOnCallingAPI:(URLResponse *)response withErrorType:(GeneralAPIRequestErrorType)errorType {
    self.errorType = errorType;
    switch (errorType) {
        case GeneralAPIRequestErrorTypeDefault:
            self.errorMessage = @"获取失败,请检查网络及其配置。";
            break;
        case GeneralAPIRequestErrorTypeNoNetWork:
            self.errorMessage = @"无网络，请开启网络。";
            break;
        case GeneralAPIRequestErrorTypeParamsError:
            self.errorMessage = @"请求参数不正确。";
            break;
        case GeneralAPIRequestErrorTypeResponseFormatUncorrect:
            self.errorMessage = @"服务器返回格式有错。";
            break;
        case GeneralAPIRequestErrorTypeServerError:
            self.errorMessage = @"服务器内部错误，请联系技术人员。";
            break;
        case GeneralAPIRequestErrorTypeServerNeedUpgrade:
            self.errorMessage = @"加载失败，请再尝试一次！";
            break;
        case GeneralAPIRequestErrorTypeErrorMessage:
            self.errorMessage = response.content[@"message"];
            break;
        case GeneralAPIRequestErrorTypeSessionExired:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestTokenTimeOut" object:nil];

            self.errorMessage = @"";
        default:
            break;
    }
    
    [self removeRequestIDWithRequestID:response.requestId];
    [self.delegate managerCallApiDidFailed:self];
}

//返回的错误类型
- (GeneralAPIRequestErrorType)responseStatuInResponse:(URLResponse *)response {
    NSString *statuCode = [NSString stringWithFormat:@"%ld", response.statuCode];
    if ([[statuCode substringToIndex:1] isEqualToString:@"5"]) {//服务器内部错误
        return GeneralAPIRequestErrorTypeServerError;
    } else {
        return GeneralAPIRequestErrorTypeDefault;
    }
}

//验证请求参数
- (BOOL)isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}

//验证返回参数
- (BOOL)isCorrectWithCallBackData:(NSDictionary *)data {
//    不存在 success 字段，或 success 不为 NSString类型，或者 success 返回 false，却没有返回 code 和 message，那么返回数据不正确。
    if (!data[@"success"] || ![data[@"success"] isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (data[@"success"] && [data[@"success"] isEqualToString:@"false"] && (!data[@"code"] || ![data[@"code"] isKindOfClass:[NSString class]] || !data[@"message"] || ![data[@"message"] isKindOfClass:[NSString class]])) {
        return NO;
    }
    return YES;
}

//获取返回内容，在这里直接解析成jsonString返回
- (id)fetchData {
    NSError *ResultInfoError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self.fetchedRawData mutableCopy] options:0 error:&ResultInfoError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma ---懒加载
- (BOOL)isReachable {
    BOOL isReachability = [AppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorMessage = @"无网络，请开启网络。";
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList {
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isLoading {
    return [self.requestIdList count] > 0 ? YES : NO;
}

- (NSString *)serviceType {
    if (!_serviceType) {
        _serviceType = ServiceRequest;
    }
    return _serviceType;
}

- (GeneralAPIRequestRequestType)requestType {
    if (!_requestType) {
        _requestType = GeneralAPIRequestRequestTypePOST;
    }
    return _requestType;
}



@end
