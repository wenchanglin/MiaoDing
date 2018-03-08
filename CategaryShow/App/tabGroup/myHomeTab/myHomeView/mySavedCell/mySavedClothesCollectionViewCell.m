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
    UIImageView *bgView;
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *tagLabel;
    UILabel * priceLabel;
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
    bgView = [UIImageView new];
    [contentView addSubview:bgView];
    // [bgView setImage:[UIImage imageNamed:@"kapian"]];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-9.2);
    }];
    
    imgView = [UIImageView new];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [imgView.layer setMasksToBounds:YES];
    [bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.bottom.equalTo(bgView.mas_bottom).offset(-73.8);
    }];
    
    titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    [bgView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(12);
        make.left.mas_equalTo(9);
        make.height.mas_equalTo(20);
    }];
    
    tagLabel = [UILabel new];
    tagLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    tagLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    [bgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(titleLabel);
        make.height.mas_equalTo(17);
    }];
    priceLabel = [UILabel new];
    priceLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.centerY.equalTo(tagLabel.mas_centerY);
    }];
    
   
    
    
}

-(void)setModel:(mySavedModel *)model
{
    _model = model;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.clothesImg]]];
    [titleLabel setText:model.clothesName];
    tagLabel.text = model.subName;
    [priceLabel setText:[NSString stringWithFormat:@"%@", model.clothesPrice]];
}

@end
