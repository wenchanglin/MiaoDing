//
//  PayInfoTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "PayInfoTableViewCell.h"

@implementation PayInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    
    UILabel *payTypeTitle = [UILabel new];
    [contentView addSubview:payTypeTitle];
    payTypeTitle.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 15)
    .widthIs(65)
    .heightIs(15);
    [payTypeTitle setFont:[UIFont systemFontOfSize:14]];
    [payTypeTitle setText:@"支付方式"];
    
    _payType = [UILabel new];
    [contentView addSubview:_payType];
    _payType.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 15)
    .widthIs(200)
    .heightIs(15);
    [_payType setFont:[UIFont systemFontOfSize:12]];
    [_payType setTextAlignment:NSTextAlignmentRight];
    
    
    
    
    
    
    UILabel *couponTitle = [UILabel new];
    [contentView addSubview:couponTitle];
    couponTitle.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(_payType, 15)
    .widthIs(65)
    .heightIs(15);
    [couponTitle setFont:[UIFont systemFontOfSize:14]];
    [couponTitle setText:@"优       惠"];
    
    
    _couponMoney = [UILabel new];
    [contentView addSubview:_couponMoney];
    _couponMoney.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_payType, 15)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(15);
    [_couponMoney setFont:[UIFont systemFontOfSize:12]];
    [_couponMoney setTextAlignment:NSTextAlignmentRight];
    
    UILabel *paymoneyTitle = [UILabel new];
    [contentView addSubview:paymoneyTitle];
    paymoneyTitle.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(_couponMoney, 15)
    .widthIs(65)
    .heightIs(15);
    [paymoneyTitle setFont:[UIFont systemFontOfSize:14]];
    [paymoneyTitle setText:@"实       付"];
    
    _payMoney = [UILabel new];
    [contentView addSubview:_payMoney];
    _payMoney.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_couponMoney, 15)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(15);
    [_payMoney setFont:Font_12];
    [_payMoney setTextAlignment:NSTextAlignmentRight];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
