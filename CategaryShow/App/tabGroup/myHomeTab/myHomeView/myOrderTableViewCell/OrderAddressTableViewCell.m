//
//  OrderAddressTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "OrderAddressTableViewCell.h"

@implementation OrderAddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp {
    UIView *contentView = self.contentView;
   
    UILabel *nameTitle = [UILabel new];
    [contentView addSubview:nameTitle];
    nameTitle.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 10)
    .widthIs(60)
    .heightIs(15);
    [nameTitle setFont:[UIFont systemFontOfSize:14]];
    [nameTitle setText:@"收货人："];
    
    _userName = [UILabel new];
    [contentView addSubview:_userName];
    _userName.sd_layout
    .leftSpaceToView(nameTitle, 5)
    .topSpaceToView(contentView, 10)
    .widthIs(120)
    .heightIs(15);
    [_userName setTextColor:getUIColor(ColorOrderGray)];
    [_userName setFont:[UIFont systemFontOfSize:14]];
    

    _userPhone = [UILabel new];
    [contentView addSubview:_userPhone];
    _userPhone.sd_layout
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 10)
    .widthIs(SCREEN_WIDTH - 165)
    .heightIs(15);
    [_userPhone setTextAlignment:NSTextAlignmentRight];
    [_userPhone setFont:Font_12];
    
    
    UILabel *addTitle = [UILabel new];
    [contentView addSubview:addTitle];
    addTitle.sd_layout
    .leftSpaceToView(contentView, 15)
    .bottomSpaceToView(contentView, 10)
    .widthIs(60)
    .heightIs(15);
    [addTitle setFont:[UIFont systemFontOfSize:14]];
    [addTitle setText:@"地   址："];
    
    _userAddress = [UILabel new];
    [contentView addSubview:_userAddress];
    _userAddress.sd_layout
    .leftSpaceToView(addTitle, 5)
    .bottomSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, 15)
    .heightIs(15);
    [_userAddress setFont:[UIFont systemFontOfSize:12]];
    [_userAddress setTextColor:getUIColor(ColorOrderGray)];
    
    _lineView = [UILabel new];
    [contentView addSubview:_lineView];
    _lineView.sd_layout
    .leftSpaceToView(contentView, 15)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(1);
    [_lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
