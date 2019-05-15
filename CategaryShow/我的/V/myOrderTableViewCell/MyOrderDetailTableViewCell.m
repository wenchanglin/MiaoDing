//
//  MyOrderDetailTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MyOrderDetailTableViewCell.h"

@implementation MyOrderDetailTableViewCell

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
    
//    _orderNumber = [UILabel new];
//    [contentView addSubview:_orderNumber];
//    
//    _orderNumber.sd_layout
//    .leftSpaceToView(contentView, 15)
//    .topSpaceToView (contentView, 10)
//    .widthIs(SCREEN_WIDTH - 90)
//    .heightIs(15);
//    [_orderNumber setFont:[UIFont systemFontOfSize:13]];
    
    
//    _orderStatus = [UILabel new];
//    [contentView addSubview:_orderStatus];
//    
//    _orderStatus.sd_layout
//    .rightSpaceToView(contentView, 15)
//    .topSpaceToView (contentView, 10)
//    .widthIs(60)
//    .heightIs(15);
//    [_orderStatus setTextAlignment:NSTextAlignmentRight];
//    [_orderStatus setFont:[UIFont systemFontOfSize:13]];
//    [_orderStatus setTextColor:getUIColor(Color_myOrderPayForAndPrice)];
    
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
    [_orderCreateTime setTextColor:getUIColor(Color_numberWatch)];
    [_orderCreateTime setFont:[UIFont systemFontOfSize:13]];
    
    
    
    
    
    _orderPayTime = [UILabel new];
    [contentView addSubview:_orderPayTime];
    _orderPayTime.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView (_orderCreateTime, 10)
    .widthIs(75)
    .heightIs(15);
    [_orderPayTime setFont:[UIFont systemFontOfSize:14]];
    
    _orderStatus = [UILabel new];
    [contentView addSubview:_orderStatus];

    _orderStatus.sd_layout
    .leftSpaceToView(_orderPayTime, 0)
    .topSpaceToView (_orderCreateTime, 10)
    .rightSpaceToView(contentView,10)
    .heightIs(15);
    [_orderStatus setTextAlignment:NSTextAlignmentLeft];
    [_orderStatus setFont:Font_13];
    
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
