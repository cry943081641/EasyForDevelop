//
//  GeneralAPIManager.h
//  iReport
//
//  Created by Cry on 2017/10/25.
//  Copyright © 2017年 foxhis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLResponse.h"

@class GeneralAPIManager;

typedef NS_ENUM(NSUInteger, GeneralAPIRequestErrorType){
    GeneralAPIRequestErrorTypeDefault, // 3xx，访问地址不对; 4xx，请求错误
    GeneralAPIRequestErrorTypeNoNetWork, // 没有网络
    GeneralAPIRequestErrorTypeParamsError, // 参数错误
    GeneralAPIRequestErrorTypeResponseFormatUncorrect, // 返服务器回数据格式不对，没有数据
    GeneralAPIRequestErrorTypeServerError, // 服务器内部错误，5xx，服务器太忙
    GeneralAPIRequestErrorTypeServerNeedUpgrade, //返回 success 为 false，但是msg中含有服务器需升级提醒的错误内容
    GeneralAPIRequestErrorTypeErrorMessage, //返回 success 为 false，msg 中有明确错误信息的，比如密码错误、用户名不存在
    GeneralAPIRequestErrorTypeSessionExired //session 失效
};

typedef NS_ENUM(NSInteger, GeneralAPIRequestRequestType) {
    GeneralAPIRequestRequestTypeGET = 0,
    GeneralAPIRequestRequestTypePOST = 1 << 0
};

@protocol GeneralAPIManagerDelegate
@required
- (void)managerCallApiDidSuccess:(GeneralAPIManager *_Nonnull)manager;
- (void)managerCallApiDidFailed:(GeneralAPIManager *)manager;
@end

@protocol GeneralAPIManagerDataSource
@required
- (nonnull NSDictionary *)paramsForApi:(GeneralAPIManager *_Nullable)manager;
@end

@interface GeneralAPIManager : NSObject
@property (nonatomic, weak) id<GeneralAPIManagerDelegate> _Nullable delegate;
@property (nonatomic, assign) id<GeneralAPIManagerDataSource> _Nonnull dataSource;

@property (nonatomic, strong) NSString * _Nullable serviceType;
@property (nonatomic, assign) GeneralAPIRequestRequestType requestType;
@property (nonatomic, assign, readonly) NSString * _Nullable errorMessage;
@property (nonatomic, assign, readonly) GeneralAPIRequestErrorType errorType;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, strong, readonly) id _Nullable fetchedRawData;
@property (nonatomic, strong) NSString * _Nonnull methodName;

// 当回调成功后 通过这个来获取到自己想要得到的格式的数据  这个协议 派生类要去实现吗
//- (id)manager:(GeneralAPIManager *)manager reformData:(NSDictionary *)data;
//- (BOOL)manager:(GeneralAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
//- (BOOL)manager:(GeneralAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
// 一定要给派生类自己内部 success后调用,用来获取数据
- (id _Nullable )fetchData;
- (NSInteger)loadData;
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

@end
