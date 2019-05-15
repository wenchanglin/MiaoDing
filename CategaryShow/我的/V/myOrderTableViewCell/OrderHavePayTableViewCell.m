//
//  OrderHavePayTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "OrderHavePayTableViewCell.h"

@implementation OrderHavePayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    
    UILabel *DDTime = [UILabel new];
    [contentView addSubview:DDTime];
    DDTime.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView (contentView, 10)
    .widthIs(75)
    .heightIs(15);
    [DDTime setFont:[UIFont systemFontOfSize:14]];
    [DDTime setText:@"订单时间："];
    
    
    
    _orderCreateTime = [UILabel new];
    [contentView addSubview:_orderCreateTime];
    _orderCreateTime.sd_layout
    .leftSpaceToView(DDTime, 0)
    .topSpaceToView (contentView, 10)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(15);
    [_orderCreateTime setTextColor:getUIColor(ColorOrderGray)];
    [_orderCreateTime setFont:[UIFont systemFontOfSize:13]];
    
    
    UILabel *PayTime = [UILabel new];
    [contentView addSubview:PayTime];
    PayTime.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView (_orderCreateTime, 10)
    .widthIs(75)
    .heightIs(15);
    [PayTime setFont:[UIFont systemFontOfSize:14]];
    [PayTime setText:@"支付时间："];
    
    _orderPayTime = [UILabel new];
    [contentView addSubview:_orderPayTime];
    _orderPayTime.sd_layout
    .leftSpaceToView(PayTime, 0)
    .topSpaceToView (_orderCreateTime, 10)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(15);
    [_orderPayTime setTextColor:getUIColor(ColorOrderGray)];
    [_orderPayTime setFont:[UIFont systemFontOfSize:13]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
