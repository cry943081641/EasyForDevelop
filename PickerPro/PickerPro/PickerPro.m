//
//  PickerPro.m
//  iReport
//
//  Created by Cry on 2018/11/26.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import "PickerPro.h"

@interface PickerPro()<UIPickerViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerToBottom;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation PickerPro

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)dealloc {
    self.picker.delegate = nil;
    self.picker.dataSource = nil;
}

- (void)setDefaultRow:(NSInteger)defaultRow {
    _defaultRow = defaultRow;
    
    [self.picker selectRow:defaultRow inComponent:self.defaultComponent animated:NO];
}

- (IBAction)confirm:(id)sender {
    [self.delegate pickerPro:self ButtonClickWithType:PickerProButtonClickConfirm andIndex:[self.picker selectedRowInComponent:0]];
}

- (IBAction)cancel:(id)sender {
    [self.delegate pickerPro:self ButtonClickWithType:PickerProButtonClickCancel andIndex:-1];
}

#pragma mark ---UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isEqual:self]) {
        return YES;
    }
    return NO;
}

#pragma mark ---UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datas.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.datas[row];
}

#pragma mark ---公共方法
- (void)showPickerInFatherView:(UIView *)fatherView {
    [fatherView addSubview:self];
    [self addGestureRecognizer:self.tap];//同一个手势不会重复添加

    [self layoutIfNeeded];//先强制刷新界面布局，立即执行
    self.pickerToBottom.constant = 0;//修改约束

    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];//再强制刷新界面布局，因为是立即执行，所以会和约束修改同步
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
@end
