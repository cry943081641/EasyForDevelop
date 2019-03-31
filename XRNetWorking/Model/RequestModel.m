//
//  RequestModel.m
//  iReport
//
//  Created by cry on 2016/12/5.
//  Copyright © 2016年 foxhis. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _sign = @"07331FD2733412A9DD7CA6EC538FB1EB";
        _ts = @"1471498765184";
        _rqid = @"PK-1";
        _loc = @"zh_CN";
        _ver = @"1.0.0";
        _appkey = @"XRLOGIN";
        _hotelid = @"XR";
        _secret = @"SeBon02D65k08cMPf";
        _params = [[NSMutableArray alloc] init];
        _extras = [[NSMutableDictionary alloc] init];
        [_extras setValue:@"YDT" forKey:@"product"];
    }
    return self;
}

- (void)setSign:(NSString *)sign {
    if (sign) {
        _sign = sign;
    } else {
        _sign = @"07331FD2733412A9DD7CA6EC538FB1EB";
    }
}

- (void)setTs:(NSString *)ts {
    if (ts) {
        _ts = ts;
    } else {
        _ts = @"1471498765184";
    }
}

- (void)setRqid:(NSString *)rqid {
    if (rqid) {
        _rqid = rqid;
    } else {
        _rqid = @"PK-1";
    }
}

- (void)setSecret:(NSString *)secret {
    if (secret) {
        _secret = secret;
    } else {
        _secret = @"SeBon02D65k08cMPf";
    }
}

- (void)setHotelid:(NSString *)hotelid {
    if (hotelid) {
        _hotelid = hotelid;
    } else {
        _hotelid = @"XR";
    }
}

- (void)setLoc:(NSString *)loc {
    if (loc) {
        _loc = loc;
    } else {
        _loc = @"zh_CN";
    }
}

- (void)setAppkey:(NSString *)appkey {
    if (appkey) {
        _appkey = appkey;
    } else {
        _appkey = @"XRLOGIN";
    }
}

- (void)setMethod:(NSString *)method {
    if (method) {
        _method = method;
    }
}

- (void)setVer:(NSString *)ver {
    if (ver) {
        _ver = ver;
    } else {
        _ver = @"1.0.0";
    }
}


@end
