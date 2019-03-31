//
//  SliderWithImageControlCell.h
//  SliderControl
//
//  Created by Cry on 2018/9/11.
//  Copyright © 2018年 foxhis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderWithImageControlCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
