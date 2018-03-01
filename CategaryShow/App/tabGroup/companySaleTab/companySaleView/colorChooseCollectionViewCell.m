//
//  colorChooseCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "colorChooseCollectionViewCell.h"

@implementation colorChooseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
        
    }
    return self;
}


-(void)setUp
{
    _colorImage = [UIImageView new];
    [self.contentView addSubview:_colorImage];
    _colorImage.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 0)
    .heightIs(50)
    .widthIs(50);
    
    _colorChoose = [UIImageView new];
    [self.contentView addSubview:_colorChoose];
    _colorChoose.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 0)
    .heightIs(50)
    .widthIs(50);
    
    _colorName = [UILabel new];
    [self.contentView addSubview:_colorName];
    
    _colorName.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(_colorChoose, 10)
    .heightIs(20)
    .widthIs(60);
    [_colorName setTextColor:[UIColor blackColor]];
    [_colorName setTextAlignment:NSTextAlignmentCenter];
    [_colorName setFont:[UIFont systemFontOfSize:12]];
    
}

@end
