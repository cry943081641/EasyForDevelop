//
//  BaseJSONModel.h
//  KFT
//
//  Created by andy on 15/11/11.
//  Copyright © 2015年 foxhis. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol BaseJSONModel
@end

@interface BaseJSONModel : JSONModel
@property (nonatomic, strong) NSString *success;
@property (nonatomic, strong) NSString<Optional> *message;
@property (nonatomic, strong) NSString<Optional> *code;
@end
