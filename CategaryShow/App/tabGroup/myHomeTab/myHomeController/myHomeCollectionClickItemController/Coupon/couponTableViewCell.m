//
//  couponTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "couponTableViewCell.h"

@implementation couponTableViewCell
{
    UILabel *priceLabel;
    UILabel *useTypeLabel;
    UILabel *typeRemarkLabel;
    UILabel *timeLabel;
    UIImageView *imageBack;
    UIImageView *rightImg;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    UIView *contentView = self.contentView;
    
    
    imageBack = [UIImageView new];
    [contentView addSubview:imageBack];
    imageBack.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);

    useTypeLabel = [UILabel new];
    useTypeLabel.font= [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    useTypeLabel.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    [contentView addSubview:useTypeLabel];
    [useTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(17);
        make.height.mas_equalTo(25);
    }];
    
    typeRemarkLabel = [UILabel new];
    typeRemarkLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    [typeRemarkLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    [contentView addSubview:typeRemarkLabel];
    [typeRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(useTypeLabel.mas_bottom).offset(2);
        make.left.equalTo(useTypeLabel);
        make.height.mas_equalTo(17);
    }];
    timeLabel = [UILabel new];
    [timeLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:10]];
    [contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeRemarkLabel.mas_bottom).offset(3);
        make.left.equalTo(typeRemarkLabel);
        make.height.mas_equalTo(14);
    }];
    
    priceLabel = [UILabel new];
    priceLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    [priceLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:20]];
    [contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(typeRemarkLabel.mas_centerY);
        make.right.mas_equalTo(-25);
    }];
    
    rightImg = [UIImageView new];
    [contentView addSubview:rightImg];
    rightImg.sd_layout
    .rightSpaceToView(contentView, 20)
    .centerYEqualToView(contentView)
    .heightIs(50)
    .widthIs(50);
    
}

-(void)setModel:(couponModel *)model
{
    _model = model;
    [priceLabel setText:[NSString stringWithFormat:@"%@%@", @"¥", model.price]];
    [useTypeLabel setText:model.useType];
    [typeRemarkLabel setText:model.typeRemark];
    [timeLabel setText:model.time];
    [imageBack setImage:[UIImage imageNamed:model.imageName]];
//    [rightImg setImage:[UIImage imageNamed:model.rightImg]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
