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
    _bigImage = [UIButton new];
    [self.contentView addSubview:_bigImage];
    [_bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.mas_equalTo(60);
    }];
    _colorImage = [UIImageView new];
    [_colorImage.layer setCornerRadius:30];
    [_colorImage.layer setMasksToBounds:YES];
    _colorImage.layer.borderWidth =1;
    [self.contentView addSubview:_colorImage];
    [_colorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bigImage);
    }];
    
    _colorChoose = [UIImageView new];
    [self.contentView addSubview:_colorChoose];
    [_colorChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_colorImage);
    }];
    
    _colorName = [UILabel new];
    [self.contentView addSubview:_colorName];
    
    [_colorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_colorImage.mas_centerX);
        make.top.equalTo(_colorImage.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    [_colorName setTextColor:[UIColor blackColor]];
    [_colorName setTextAlignment:NSTextAlignmentCenter];
    [_colorName setFont:[UIFont systemFontOfSize:12]];
}
@end
