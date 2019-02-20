//
//  ViewController.m
//  SliderControl
//
//  Created by Cry on 2018/9/11.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import "ViewController.h"
#import "SliderControl.h"

@interface ViewController ()<SliderControlDelegate>
@property (strong, nonatomic) SliderControl *sliderControlA;
@property (strong, nonatomic) SliderControl *sliderControlB;
@property (strong, nonatomic) SliderControl *sliderControlC;
@property (strong, nonatomic) SliderControl *sliderControlD;
@property (weak, nonatomic) IBOutlet UIView *AContainer;
@property (weak, nonatomic) IBOutlet UIView *BContainer;
@property (weak, nonatomic) IBOutlet UIView *CContainer;
@property (weak, nonatomic) IBOutlet UIView *DContainer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //一定要在 viewDidLoad里对控件进行初始化的属性赋值，因为控件内部是在 drawRect里进行属性赋值的，而drawRect 的调用在 viewDidLoad方法之后调用
    [self.AContainer addSubview:self.sliderControlA];
    [self.BContainer addSubview:self.sliderControlB];
    [self.CContainer addSubview:self.sliderControlC];
    [self.DContainer addSubview:self.sliderControlD];

}

#pragma mark ---SliderControlDelegate
- (void)sliderControl:(SliderControl *)sliderControl choosePartAtIndex:(NSInteger)index {
    NSLog(@"当前点击的是 SliderControl ·········%@  \n  ············· 第 %zd 个位置", sliderControl, index);
}

#pragma mark ---初始化
- (SliderControl *)sliderControlA {
    if (!_sliderControlA) {
        NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"选项一", @"选项二", @"选项三", nil];
        _sliderControlA = [[[NSBundle mainBundle] loadNibNamed:@"SliderControl" owner:nil options:nil] firstObject];
        _sliderControlA.titles = titles;
        _sliderControlA.cellTitleColor = [UIColor colorWithRed:49 / 255.0 green:195 / 255.0 blue:124 / 255.0 alpha:1];
        _sliderControlA.cellUnselectedTitleColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];;
        _sliderControlA.sliderControlType = SliderControlWithBottomTint;
        _sliderControlA.sliderItemWidthType = SliderItemEqualWidth;
        _sliderControlA.delegate = self;
        _sliderControlA.sliderBackgroundColor = [UIColor whiteColor];
        _sliderControlA.frame = self.AContainer.bounds;
    }
    return _sliderControlA;
}

- (SliderControl *)sliderControlB {
    if (!_sliderControlB) {
        NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"维修房", @"很长很长很长的标题", @"自用房房", @"大床房", @"抹尘房", @"钟点房", @"锁房", nil];
        _sliderControlB = [[[NSBundle mainBundle] loadNibNamed:@"SliderControl" owner:nil options:nil] firstObject];
        _sliderControlB.titles = titles;
        _sliderControlB.cellTitleColor = [UIColor colorWithRed:49 / 255.0 green:195 / 255.0 blue:124 / 255.0 alpha:1];
        _sliderControlB.cellUnselectedTitleColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
        _sliderControlB.sliderControlType = SliderControlWithBottomTint;
        _sliderControlB.sliderItemWidthType = SliderItemWidthCustom;
        _sliderControlB.delegate = self;
        _sliderControlB.sliderBackgroundColor = [UIColor whiteColor];
        _sliderControlB.frame = self.BContainer.bounds;
    }
    return _sliderControlB;
}

- (SliderControl *)sliderControlC {
    if (!_sliderControlC) {
        NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"抹尘房", @"钟点房", @"锁房", nil];
        _sliderControlC = [[[NSBundle mainBundle] loadNibNamed:@"SliderControl" owner:nil options:nil] firstObject];
        _sliderControlC.titles = titles;
        _sliderControlC.cellTitleColor = [UIColor colorWithRed:49 / 255.0 green:195 / 255.0 blue:124 / 255.0 alpha:1];
        _sliderControlC.cellUnselectedTitleColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
        _sliderControlC.sliderControlType = SliderControlWithImage;
        _sliderControlC.sliderItemWidthType = SliderItemWidthCustom;
        _sliderControlC.delegate = self;
        _sliderControlC.sliderBackgroundColor = [UIColor whiteColor];
        _sliderControlC.frame = self.CContainer.bounds;
    }
    return _sliderControlC;
}

- (SliderControl *)sliderControlD {
    if (!_sliderControlD) {
        NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"抹尘房", @"钟点房", @"锁房", nil];
        _sliderControlD = [[[NSBundle mainBundle] loadNibNamed:@"SliderControl" owner:nil options:nil] firstObject];
        _sliderControlD.titles = titles;
        _sliderControlD.cellTitleColor = [UIColor colorWithRed:252 / 255.0 green:136 / 255.0 blue:39 / 255.0 alpha:1];
        _sliderControlD.cellUnselectedTitleColor = [UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1];
        _sliderControlD.sliderControlType = SliderControlWithImage;
        _sliderControlD.cellImageSize = CGSizeMake(20, 20);
        _sliderControlD.selectedImageName = @"RepairScoreStar";
        _sliderControlD.unselectedImageName = @"RepairScoreStarGray";
        _sliderControlD.sliderItemWidthType = SliderItemWidthCustom;
        _sliderControlD.delegate = self;
        _sliderControlD.sliderBackgroundColor = [UIColor whiteColor];
        _sliderControlD.frame = self.CContainer.bounds;
    }
    return _sliderControlD;
}

@end
