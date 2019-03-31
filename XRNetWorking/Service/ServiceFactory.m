//
//  ServiceFactory.m
//  shengyin
//
//  Created by andy on 15/8/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ServiceFactory.h"
#import "RequestService.h"

NSString * const ServiceRequest = @"ServiceRequest";

@interface ServiceFactory ()
@property (nonatomic, strong) NSMutableDictionary *serviceStorage;
@end

@implementation ServiceFactory

#pragma mark -getters and setters
- (NSMutableDictionary *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
-(Service<ServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier {
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithidentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

-(Service<ServiceProtocal> *)newServiceWithidentifier:(NSString *)identifier {
    if ([identifier isEqualToString:ServiceRequest]) {
        return [[RequestService alloc] init];
    }
    
    return nil;
}

@end
