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
    
    
    
//    UILabel *label = [UILabel new];
//    [contentView addSubview:label];
//    label.sd_layout
//    .leftSpaceToView(contentView,20)
//    .widthIs(15)
//    .heightIs(20)
//    .topSpaceToView(contentView,27);
//    [label setFont:[UIFont systemFontOfSize:12]];
//    [label setText:@"￥"];
    
    
    
    
    priceLabel = [UILabel new];
    [contentView addSubview:priceLabel];
    priceLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .widthIs(80)
    .bottomSpaceToView(contentView, 30)
    .topSpaceToView(contentView,25);
    [priceLabel setFont:Font_16];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    useTypeLabel = [UILabel new];
    [contentView addSubview:useTypeLabel];
    useTypeLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 80)
    .topSpaceToView(contentView, 20)
    .heightIs(15);
    [typeRemarkLabel setFont:Font_18];
    
    typeRemarkLabel = [UILabel new];
    [contentView addSubview:typeRemarkLabel];
    typeRemarkLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 80)
    .topSpaceToView(useTypeLabel, 3)
    .heightIs(15);
    [typeRemarkLabel setFont:[UIFont systemFontOfSize:12]];
    
    timeLabel = [UILabel new];
    [contentView addSubview:timeLabel];
    timeLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 80)
    .topSpaceToView(typeRemarkLabel, 4)
    .heightIs(15);
    [timeLabel setFont:[UIFont systemFontOfSize:10]];
    
    
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
