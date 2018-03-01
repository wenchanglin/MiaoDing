//
//  mySavedClothesCollectionViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/18.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "mySavedClothesCollectionViewCell.h"

@implementation mySavedClothesCollectionViewCell
{
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesPrice;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .bottomSpaceToView(contentView, 10);
    [clothesImg setContentMode:UIViewContentModeScaleAspectFill];
    [clothesImg.layer setMasksToBounds:YES];
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    
//    clothesName.sd_layout
//    .leftSpaceToView(contentView, 12)
//    .topSpaceToView(clothesImg, 0)
//    .bottomEqualToView(contentView)
//    .rightSpaceToView(contentView,16);
//    [clothesName setFont:[UIFont systemFontOfSize:15]];
    
   
    
    
}

-(void)setModel:(mySavedModel *)model
{
    _model = model;
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.clothesImg]]];
    [clothesName setText:model.clothesName];
    [clothesPrice setText:[NSString stringWithFormat:@"¥%@", model.clothesPrice]];
}

@end
