//
//  SafeAreaHelper.m
//  KFT
//
//  Created by Cry on 2018/9/30.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import "SafeAreaHelper.h"

@implementation SafeAreaHelper

+ (CGRect)getSafeLayoutGuideForView:(UIView *)view {
    CGRect rect;
    if (@available(iOS 11.0, *)) {
        rect = view.safeAreaLayoutGuide.layoutFrame;
    } else {
        rect = view.frame;
    }
    return rect;
}

+ (UIEdgeInsets)getSafeAreaInsetsForView:(UIView *)view {
    UIEdgeInsets edgeInsets;
    if (@available(iOS 11.0, *)) {
        edgeInsets = view.safeAreaInsets;
    } else {
        edgeInsets = UIEdgeInsetsZero;
    }
    return edgeInsets;
}

@end
