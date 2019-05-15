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
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    [nameTitle setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    nameTitle.textColor = [UIColor colorWithHexString:@"#222222"];
    [nameTitle setText:@"收货人："];
    
    _userName = [UILabel new];
    [contentView addSubview:_userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle.mas_right).offset(5);
        make.top.equalTo(nameTitle);
        make.height.mas_equalTo(20);
    }];
    [_userName setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    _userName.textColor = [UIColor colorWithHexString:@"#222222"];


    _userPhone = [UILabel new];
    [contentView addSubview:_userPhone];
    [_userPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName);
        make.right.mas_equalTo(-14);
        make.height.mas_equalTo(20);
    }];
    [_userPhone setTextAlignment:NSTextAlignmentRight];
    [_userPhone setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    _userPhone.textColor = [UIColor colorWithHexString:@"#222222"];
    
    UILabel *addTitle = [UILabel new];
    [contentView addSubview:addTitle];
    [addTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(15);
        make.left.mas_equalTo(11);
        make.height.mas_equalTo(20);
    }];
    [addTitle setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    [addTitle setText:@"地   址："];
    
    _userAddress = [UILabel new];
    [contentView addSubview:_userAddress];
    [_userAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addTitle);
        make.left.equalTo(addTitle.mas_right);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    [_userAddress setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    _userAddress.numberOfLines =2;
    _userAddress.textColor = [UIColor colorWithHexString:@"#222222"];
    UIImageView * rightImageView = [UIImageView new];
    rightImageView.image = [UIImage imageNamed:@"rightDes"];
    [contentView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-11.6);
        make.centerY.equalTo(addTitle.mas_centerY);
    }];
//    _lineView = [UILabel new];
//    [contentView addSubview:_lineView];
//    _lineView.sd_layout
//    .leftSpaceToView(contentView, 15)
//    .bottomEqualToView(contentView)
//    .widthIs(SCREEN_WIDTH - 30)
//    .heightIs(1);
//    [_lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
