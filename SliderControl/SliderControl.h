//
//  SliderControl.h
//  SliderControl
//
//  Created by Cry on 2018/9/11.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderControl;
//控件是否带图的 type
typedef NS_ENUM(NSInteger, SliderControlType) {
    SliderControlWithBottomTint = 0,//无图模式，底部色条
    SliderControlWithImage = 1//有图模式
};
//控件按钮是否等宽的 type
typedef NS_ENUM(NSInteger, SliderItemWidthType) {
    SliderItemWidthCustom = 0,//
    SliderItemEqualWidth = 1 //适用于标题等分父视图宽度的情况
};

@protocol SliderControlDelegate <NSObject>
@required
- (void)sliderControl:(SliderControl *)sliderControl choosePartAtIndex:(NSInteger)index;
@end

@interface SliderControl : UIView
@property (assign, nonatomic) SliderControlType sliderControlType;
@property (assign, nonatomic) SliderItemWidthType sliderItemWidthType;
@property (assign, nonatomic) id<SliderControlDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<NSString *> *titles;//标题数组
@property (nonatomic, assign) BOOL canRepeatSelect;//是否可以重复点击
@property (nonatomic, assign) NSInteger selectRow;//选中的按钮下标

@property (nonatomic, strong) UIColor *cellTitleColor;//选中按钮标题颜色
@property (nonatomic, strong) UIColor *cellUnselectedTitleColor;//未选中按钮标题颜色
@property (nonatomic, strong) UIColor *cellSelectedBackgroundColor;//选中按钮的背景色
@property (nonatomic, strong) UIColor *sliderBackgroundColor;//控件背景色，也是未选择按钮的背景色

//以下属性设置需要在sliderControlType 为SliderControlWithImage才生效
@property (nonatomic, strong) NSString *selectedImageName;//选中的图片
@property (nonatomic, strong) NSString *unselectedImageName;//未选中的图片
@property (nonatomic) CGSize cellImageSize;//图片尺寸

//更换标题的方法
- (void)changeTileAtIndex:(int)index withTitle:(NSString *)title;

@end
