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
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(12);
        make.left.mas_equalTo(9);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    tagLabel = [UILabel new];
    tagLabel.textAlignment=NSTextAlignmentCenter;
    tagLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    tagLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    [bgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
        make.centerX.equalTo(titleLabel.mas_centerX);
        make.height.mas_equalTo(17);
    }];
    priceLabel = [UILabel new];
    priceLabel.textAlignment=NSTextAlignmentCenter;
    priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagLabel.mas_bottom).offset(2);
        make.right.mas_equalTo(-9);
        make.centerX.equalTo(titleLabel.mas_centerX);
    }];
    
   
    
    
}

-(void)setModel:(mySavedModel *)model
{
    _model = model;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.car_img]]];
    [titleLabel setText:model.name];
    tagLabel.text = model.content;
    [priceLabel setText:[NSString stringWithFormat:@"%@", model.sell_price]];
}
-(void)setModel2:(myCollectModel *)model2
{
    _model2 = model2;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model2.img]]];
    [titleLabel setText:model2.name];
    tagLabel.text = model2.sub_name;
    [priceLabel setText:[NSString stringWithFormat:@"%@", model2.price]];
}
@end
