//
//  mainClothesSaleCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "mainClothesSaleCollectionViewCell.h"
#import "NSObject+LZSwipeCategory.h"
@implementation mainClothesSaleCollectionViewCell

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
    UIImageView *shadowView = [UIImageView new];
//    shadowView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [contentView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    _imageDesigner = [UIImageView new];
    _imageDesigner.contentMode=UIViewContentModeScaleAspectFill;
    [_imageDesigner.layer setMasksToBounds:YES];
    [shadowView addSubview:_imageDesigner];
    [_imageDesigner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(146);
    }];
   
    _nameLabel = [UILabel new];
    [_nameLabel setFont:[UIFont fontWithName:@"PingFangTC-Regular" size:12]];
    [_nameLabel setTextColor:[UIColor colorWithHexString:@"#202020"]];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [shadowView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageDesigner.mas_bottom).offset(2.5);
        make.centerX.equalTo(_imageDesigner.mas_centerX);
        make.height.mas_equalTo(20);
    }];
   
    _priceLabel = [UILabel new];
    [_priceLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14]];
    [_priceLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    [shadowView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(4);
        make.centerX.equalTo(_imageDesigner.mas_centerX);
        make.height.mas_equalTo(20);
    }];
}


@end
