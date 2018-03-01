//
//  waitToPayHeadTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "waitToPayHeadTableViewCell.h"

@implementation waitToPayHeadTableViewCell

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
    
    _orderCreateTime = [UILabel new];
    [contentView addSubview:_orderCreateTime];
    _orderCreateTime.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView (contentView, 10)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(15);
    [_orderCreateTime setFont:[UIFont systemFontOfSize:13]];
    
    _orderPayTime = [UILabel new];
    [contentView addSubview:_orderPayTime];
    _orderPayTime.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView (_orderCreateTime, 10)
    .widthIs(60)
    .heightIs(15);
    [_orderPayTime setFont:[UIFont systemFontOfSize:13]];
    
    _orderStatus = [UILabel new];
    [contentView addSubview:_orderStatus];
    
    _orderStatus.sd_layout
    .leftSpaceToView(_orderPayTime, 0)
    .topSpaceToView (_orderCreateTime, 10)
    .widthIs(60)
    .heightIs(15);
    [_orderStatus setTextAlignment:NSTextAlignmentLeft];
    [_orderStatus setFont:[UIFont systemFontOfSize:13]];
    [_orderStatus setTextColor:getUIColor(Color_myOrderPayForAndPrice)];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
