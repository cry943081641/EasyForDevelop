//
//  SafeAreaHelper.h
//  KFT
//
//  Created by Cry on 2018/9/30.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SafeAreaHelper : NSObject
+ (CGRect)getSafeLayoutGuideForView:(UIView *)view;
+ (UIEdgeInsets)getSafeAreaInsetsForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
