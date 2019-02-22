//
//  DatePickerPro.h
//  DatePickerPro
//
//  Created by Cry on 2018/9/18.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (int, DatePickerProButtonClickType) {
    DatePickerProButtonClickCancel = 0,
    DatePickerProButtonClickConfirm
};

@class DatePickerPro;

@protocol DatePickerProDelegate <NSObject>
- (void)pickerPro:(DatePickerPro *)picker ButtonClickWithType:(DatePickerProButtonClickType)type stringFromDate:(NSString *)date;

@end

@interface DatePickerPro : UIView
@property (assign, nonatomic) UIDatePickerMode datePickerMode;
@property (assign, nonatomic) NSString *dateFormatter;//默认值 yyyy-MM-dd

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (assign, nonatomic) id<DatePickerProDelegate> delegate;


- (void)showPickerInFatherView:(UIView *)fatherView;
- (void)dismissPickerFromFatherView:(UIView *)fatherView;

@end
