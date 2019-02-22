//
//  DatePickerPro.m
//  DatePickerPro
//
//  Created by Cry on 2018/9/18.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import "DatePickerPro.h"

@interface DatePickerPro()<UIPickerViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerToBottom;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation DatePickerPro

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.datePicker setDate:date animated:NO];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.datePicker.datePickerMode = self.datePickerMode;
}

- (IBAction)confirm:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = self.dateFormatter;

    [self.delegate pickerPro:self ButtonClickWithType:DatePickerProButtonClickConfirm stringFromDate:[dateFormatter stringFromDate:self.datePicker.date]];
}

- (IBAction)cancel:(id)sender {
    [self.delegate pickerPro:self ButtonClickWithType:DatePickerProButtonClickCancel stringFromDate:nil];
}

#pragma mark ---公共方法
- (void)showPickerInFatherView:(UIView *)fatherView {
    [fatherView addSubview:self];
    [self addGestureRecognizer:self.tap];//同一个手势不会重复添加
    
    [self layoutIfNeeded];//先强制刷新界面布局，立即执行
    self.pickerToBottom.constant = 0;//修改约束
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];//再强制刷新界面布局，因为是立即执行，所以会和约束修改同步执行
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }];
}

- (void)dismissPickerFromFatherView:(UIView *)fatherView {
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerToBottom.constant = -240;
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark ---初始化
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickerFromFatherView:)];
        _tap.delegate = self;
    }
    return _tap;
}

- (NSString *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
