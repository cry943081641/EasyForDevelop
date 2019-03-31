//
//  SliderControl.m
//  SliderControl
//
//  Created by Cry on 2018/9/11.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import "SliderControl.h"
#import "SliderControlCell.h"
#import "SliderWithImageControlCell.h"
#import <objc/runtime.h>

#define MINIMUN_SPACING 10
#define NON_SELECT_ROW 9999
//如果不需要动态计算 cell 的宽度，可以注释sizeForItemAtIndexPath方法，直接在这里设置itemSize
#define BOTTOM_TINT_DEFAULT_CELL_SIZE CGSizeMake(70, CGRectGetHeight(self.frame))
#define IMAGE_DEFAULT_CELL_SIZE CGSizeMake(80, CGRectGetHeight(self.frame))

@interface SliderControl()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *cellWidths;

@end

@implementation SliderControl

static NSString * const sliderControlCellIdentifier = @"SliderControlCellIdentifier";
static NSString * const sliderWithImageControlCellIdentifier = @"SliderWithImageControlCellIdentifier";

- (void)drawRect:(CGRect)rect {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat toTop = 0;
    CGFloat toLeft = (self.sliderItemWidthType == SliderItemWidthCustom) ? 10 : 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(toTop, toLeft, toTop, toLeft);
    flowLayout.minimumInteritemSpacing = MINIMUN_SPACING;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    if (self.sliderControlType == SliderControlWithBottomTint) {
        flowLayout.itemSize = BOTTOM_TINT_DEFAULT_CELL_SIZE;
        [self.collectionView registerNib:[UINib nibWithNibName:@"SliderControlCell" bundle:nil] forCellWithReuseIdentifier:sliderControlCellIdentifier];
    } else {
        flowLayout.itemSize = IMAGE_DEFAULT_CELL_SIZE;
        [self.collectionView registerNib:[UINib nibWithNibName:@"SliderWithImageControlCell" bundle:nil] forCellWithReuseIdentifier:sliderWithImageControlCellIdentifier];
    }
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.scrollEnabled = !(self.sliderItemWidthType == SliderItemEqualWidth);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView reloadData];
}

#pragma mark ---collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth;
    if (self.sliderItemWidthType == SliderItemWidthCustom) {
        cellWidth = [self.cellWidths[indexPath.row] floatValue];
    } else {
        cellWidth = (CGRectGetWidth(self.frame) - MINIMUN_SPACING * (self.titles.count - 1)) / self.titles.count;
    }
    return CGSizeMake(cellWidth, CGRectGetHeight(self.frame));
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UINib *nib = [UINib nibWithNibName:@"SliderControlCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:sliderControlCellIdentifier];
   
    if (self.sliderControlType == SliderControlWithBottomTint) {
        SliderControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sliderControlCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = self.sliderBackgroundColor;
        cell.title.text = self.titles[indexPath.row];
        if (self.selectRow == indexPath.row) {
            cell.backgroundColor = self.cellSelectedBackgroundColor;
            cell.title.textColor = (self.cellTitleColor) ? self.cellTitleColor : self.cellUnselectedTitleColor;
            cell.bottomView.hidden = NO;
            cell.bottomView.backgroundColor = (self.cellTitleColor) ? self.cellTitleColor : self.cellUnselectedTitleColor;
        } else {
            cell.title.textColor = self.cellUnselectedTitleColor;
            cell.bottomView.hidden = YES;
            cell.bottomView.backgroundColor = self.cellUnselectedTitleColor;
        }
        return cell;
    } else {
        SliderWithImageControlCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sliderWithImageControlCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = self.sliderBackgroundColor;
        cell.title.text = self.titles[indexPath.row];
        cell.imageWidth.constant = self.cellImageSize.width;
        cell.imageHeight.constant = self.cellImageSize.height;
        if (self.selectRow == indexPath.row) {
            cell.backgroundColor = self.cellSelectedBackgroundColor;
            cell.image.image = [UIImage imageNamed:self.selectedImageName];
            cell.title.textColor = (self.cellTitleColor) ? self.cellTitleColor : self.cellUnselectedTitleColor;
        } else {
            cell.image.image = [UIImage imageNamed:self.unselectedImageName];
            cell.title.textColor = self.cellUnselectedTitleColor;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canRepeatSelect && self.selectRow == indexPath.row) {
        self.selectRow = NON_SELECT_ROW;
    } else {
        self.selectRow = indexPath.row;
    }
    [collectionView reloadData];
    
    [self.delegate sliderControl:self choosePartAtIndex:self.selectRow];

}

#pragma mark ---自定义方法

/**
 计算 cell 的宽度
 */
- (void)reloadCellWidths {
    [self.cellWidths removeAllObjects];
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        if (self.sliderControlType == SliderControlWithBottomTint) {
            //仅文字的 cell 宽度 = 文字长度 + 左右边距
            CGFloat cellWidth = title.length * 15 + (2 * 5);
            [self.cellWidths addObject:[NSNumber numberWithFloat:cellWidth]];
        } else {
            //带图片的 cell 宽度 = 文字长度 + 图文间距 + 图片长度 + 左右边距
            CGFloat cellWidth = title.length * 15 + 5 + self.cellImageSize.width + (2 * 5);
            [self.cellWidths addObject:[NSNumber numberWithFloat:cellWidth]];
        }
    }
}

#pragma mark ---set 方法
- (void)setTitles:(NSMutableArray<NSString *> *)titles {
    _titles = titles;

    [self reloadCellWidths];
    [self.collectionView reloadData];
}

- (void)setSelectRow:(NSInteger)selectRow {
    _selectRow = selectRow;

    [self.collectionView reloadData];
}

- (void)setCellTitleColor:(UIColor *)cellTitleColor {
    _cellTitleColor = cellTitleColor;
    [self.collectionView reloadData];
}

- (void)setCellUnselectedTitleColor:(UIColor *)cellUnselectedTitleColor {
    _cellUnselectedTitleColor = cellUnselectedTitleColor;

    [self.collectionView reloadData];
}

- (void)setSliderBackgroundColor:(UIColor *)sliderBackgroundColor {
    _sliderBackgroundColor = sliderBackgroundColor;
    
    self.collectionView.backgroundColor = sliderBackgroundColor;
    [self.collectionView reloadData];
}

- (void)setCellSelectedBackgroundColor:(UIColor *)cellSelectedBackgroundColor {
    _cellSelectedBackgroundColor = cellSelectedBackgroundColor;
    
    [self.collectionView reloadData];
}

- (void)setSliderControlType:(SliderControlType)sliderControlType {
    _sliderControlType = sliderControlType;
    
    [self reloadCellWidths];
    //设置了类型，重新调用 drawRect方法，以保证设置的类型展示
    [self setNeedsDisplay];
}

- (void)setCellImageSize:(CGSize)cellImageSize {
    _cellImageSize = cellImageSize;
    
    [self reloadCellWidths];
    [self.collectionView reloadData];
}

- (NSMutableArray<NSNumber *> *)cellWidths {
    if (!_cellWidths) {
        _cellWidths = [[NSMutableArray alloc] init];
    }
    return _cellWidths;
}

#pragma mark ---以下代码全为设置属性默认值
+(void)load {
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        Class class = [self class];
        // 选择三个系统方法
        SEL system_init          = @selector(init);
        SEL system_initWithFrame = @selector(initWithFrame:);
        SEL system_awakeFromeNib = @selector(awakeFromNib);
        // 选择三个自定义方法（准备替换系统方法）
        // 动态给类添加方法. 为了防止在实现的时候方法名重复，所以自定义的方法名要尽量奇怪。奇怪到基本不会重复
        // 我使用了驼峰式命名+下划线命名+一串数字+一个字符串的方式。
        SEL custem_init          = @selector(custemInit_custom_init_9527_thisID);
        SEL custem_initWithFrame = @selector(custemInit_custom_init_9527_thisIDWithFrame:);
        SEL custom_awakeFromeNib = @selector(custemAwakeFromNib_custom_awake_from_Nib_9527_thisID);
        // 方法
        Method method_system_init          = class_getInstanceMethod(class, system_init);
        Method method_system_initWithFrame = class_getInstanceMethod(class, system_initWithFrame);
        Method method_system_awakeFromeNib = class_getInstanceMethod(class, system_awakeFromeNib);
        Method method_custom_init          = class_getInstanceMethod(class, custem_init);
        Method method_custom_initWithFrame = class_getInstanceMethod(class, custem_initWithFrame);
        Method method_custom_awakeFromeNib = class_getInstanceMethod(class, custom_awakeFromeNib);
        // 动态给类添加方法。并返回是否添加成功
        BOOL didAddMethod_init = class_addMethod(class, system_init, method_getImplementation(method_custom_init), method_getTypeEncoding(method_custom_init));
        BOOL didAddMethod_initWithFrame = class_addMethod(class, system_initWithFrame, method_getImplementation(method_custom_initWithFrame), method_getTypeEncoding(method_custom_initWithFrame));
        BOOL didAddMethod_awakeFromeNib = class_addMethod(class, system_awakeFromeNib, method_getImplementation(method_custom_awakeFromeNib), method_getTypeEncoding(method_custom_awakeFromeNib));
        // 开始替换啦
        if (didAddMethod_init) {
            class_replaceMethod(class, custem_init, method_getImplementation(method_system_init), method_getTypeEncoding(method_system_init));
        }else{
            method_exchangeImplementations(method_system_init, method_custom_init);
        }
        if (didAddMethod_initWithFrame) {
            class_replaceMethod(class, custem_initWithFrame, method_getImplementation(method_system_initWithFrame), method_getTypeEncoding(method_system_initWithFrame));
        }else{
            method_exchangeImplementations(method_system_initWithFrame, method_custom_initWithFrame);
        }
        if (didAddMethod_awakeFromeNib) {
            class_replaceMethod(class, custom_awakeFromeNib, method_getImplementation(method_system_awakeFromeNib), method_getTypeEncoding(method_system_awakeFromeNib));
        }else{
            method_exchangeImplementations(method_system_awakeFromeNib, method_custom_awakeFromeNib);
        }
    });
}

#pragma mark - 在以下方法中设置默认值
-(instancetype)custemInit_custom_init_9527_thisID {
    id _self = [self custemInit_custom_init_9527_thisID];
    // 在此设置默认值
    self.cellTitleColor = [UIColor colorWithRed:49 / 255.0 green:195 / 255.0 blue:124 / 255.0 alpha:1];
    self.cellUnselectedTitleColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.sliderBackgroundColor = [UIColor colorWithRed:90 / 255.0 green:89 / 255.0 blue:92 / 255.0 alpha:1];
    self.selectedImageName = @"CheckSelected.png";
    self.unselectedImageName = @"CheckUnselected.png";
    self.cellImageSize = CGSizeMake(13.f, 13.f);
    return _self;
}

-(instancetype)custemInit_custom_init_9527_thisIDWithFrame:(CGRect)frame {
    id _self = [self custemInit_custom_init_9527_thisIDWithFrame:frame];
    // 在此设置默认值
    self.cellTitleColor = [UIColor colorWithRed:49 / 255.0 green:195 / 255.0 blue:124 / 255.0 alpha:1];
    self.cellUnselectedTitleColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.sliderBackgroundColor = [UIColor colorWithRed:90 / 255.0 green:89 / 255.0 blue:92 / 255.0 alpha:1];
    self.selectedImageName = @"CheckSelected.png";
    self.unselectedImageName = @"CheckUnselected.png";
    self.cellImageSize = CGSizeMake(13.f, 13.f);
    
    return _self;
}

-(void)custemAwakeFromNib_custom_awake_from_Nib_9527_thisID {
    [self custemAwakeFromNib_custom_awake_from_Nib_9527_thisID];
    // 在此设置默认值
    self.cellTitleColor = [UIColor colorWithRed:49 / 255.0 green:195 / 255.0 blue:124 / 255.0 alpha:1];
    self.cellUnselectedTitleColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.sliderBackgroundColor = [UIColor colorWithRed:90 / 255.0 green:89 / 255.0 blue:92 / 255.0 alpha:1];
    self.selectedImageName = @"CheckSelected.png";
    self.unselectedImageName = @"CheckUnselected.png";
    self.cellImageSize = CGSizeMake(13.f, 13.f);
}

#pragma mark ---公共方法
- (void)changeTileAtIndex:(int)index withTitle:(NSString *)title {
    NSMutableArray *temp = self.titles;
    [temp replaceObjectAtIndex:index withObject:title];
    self.titles = temp;
}

@end
