//
//  partDetailCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/28.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "partDetailCollectionViewCell.h"

@implementation partDetailCollectionViewCell


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
    _partImgView = [UIImageView new];
    [contentView addSubview:_partImgView];
    _partImgView.sd_layout
    .centerXEqualToView(contentView)
    .centerYEqualToView(contentView)
    .widthIs(50)
    .heightIs(50);
    [_partImgView.layer setCornerRadius:25];
    [_partImgView.layer setMasksToBounds:YES];
    
    _imageChoose = [UIImageView new];
    [contentView addSubview:_imageChoose];
    _imageChoose.sd_layout
    .centerXEqualToView(contentView)
    .centerYEqualToView(contentView)
    .widthIs(50)
    .heightIs(50);
    [_imageChoose.layer setCornerRadius:25];
    [_imageChoose.layer setMasksToBounds:YES];
    
    
    
    
    
}
@end
