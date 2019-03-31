//
//  RequestModel.h
//  iReport
//
//  Created by cry on 2016/12/5.
//  Copyright © 2016年 foxhis. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RequestModel : JSONModel
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *ts;
@property (nonatomic, strong) NSString *rqid;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *hotelid;
@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *loc;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *ver;
@property (nonatomic, strong) NSString *tenantid;
@property (nonatomic, strong) NSMutableDictionary<Optional> *extras;
@property (nonatomic, strong) NSMutableArray *params;

+ (instancetype)sharedInstance;
@end
