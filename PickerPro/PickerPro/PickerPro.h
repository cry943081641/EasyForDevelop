//
//  PickerPro.h
//  iReport
//
//  Created by Cry on 2018/11/26.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (int, PickerProButtonClickType) {
    PickerProButtonClickCancel = 0,
    PickerProButtonClickConfirm
};

@class PickerPro;
@protocol PickerProDelegate <NSObject>
//如果取消，返回-1
- (void)pickerPro:(PickerPro *)picker ButtonClickWithType:(PickerProButtonClickType)type andIndex:(NSInteger)index;
@end

@interface PickerPro : UIView
@property (nonatomic, strong) NSArray<NSString *> *datas;
@property (assign, nonatomic) NSInteger defaultRow;
@property (assign, nonatomic) NSInteger defaultComponent;
@property (assign, nonatomic) id<PickerProDelegate> delegate;

- (void)showPickerInFatherView:(UIView *)fatherView;
- (void)dismissPickerFromFatherView:(UIView *)fatherView;

@end

NS_ASSUME_NONNULL_END
