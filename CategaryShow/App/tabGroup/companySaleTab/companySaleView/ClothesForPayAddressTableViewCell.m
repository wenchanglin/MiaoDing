//
//  ClothesForPayAddressTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/10/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ClothesForPayAddressTableViewCell.h"

@implementation ClothesForPayAddressTableViewCell
{
    UILabel *userName;
    UILabel *userPhone;
    UILabel *userAddress;
    UILabel *defaultAddress;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    userName = [UILabel new];
    [contentView addSubview:userName];
    userName.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(contentView, 12.5)
    .heightIs(20)
    .widthIs(70);
    [userName setTextColor:getUIColor(Color_myBagToPayButton)];
    [userName setFont:[UIFont systemFontOfSize:16]];
    
    defaultAddress = [UILabel new];
    [contentView addSubview:defaultAddress];
    defaultAddress.sd_layout
    .leftSpaceToView(contentView, 15)
    .bottomSpaceToView(contentView, 10)
    .heightIs(20)
    .widthIs(40);
    [defaultAddress.layer setCornerRadius:1];
    [defaultAddress.layer setMasksToBounds:YES];
    [defaultAddress setTextAlignment:NSTextAlignmentCenter];
    [defaultAddress setFont:[UIFont systemFontOfSize:12]];
    [defaultAddress setTextColor:[UIColor whiteColor]];
    [defaultAddress setBackgroundColor:getUIColor(Color_buyColor)];
    [defaultAddress setText:@"默认"];
    
    
    
    userPhone = [UILabel new];
    [contentView addSubview:userPhone];
    userPhone.sd_layout
    .leftSpaceToView(contentView, 120)
    .topSpaceToView(contentView, 12.5)
    .heightIs(20)
    .rightSpaceToView(contentView, 15);
    [userPhone setTextColor:getUIColor(Color_myBagToPayButton)];
    [userPhone setFont:[UIFont systemFontOfSize:16]];
    
    userAddress = [UILabel new];
    [contentView addSubview:userAddress];
    userAddress.sd_layout
    .leftSpaceToView(contentView, 120)
    .bottomSpaceToView(contentView, 10)
    .heightIs(20)
    .rightSpaceToView(contentView, 15);
    [userAddress setTextColor:getUIColor(Color_myBagUpdate)];
    [userAddress setFont:[UIFont systemFontOfSize:12]];
    
    
    
    
}


-(void)setModel:(AddressModel *)model
{
    _model = model;
    [userName setText:model.userName];
    [userPhone setText:model.userPhone];
    [userAddress setText:model.userAddress];
    if ([model.addressDefault isEqualToString:@"0"]) {
        [defaultAddress setHidden:YES];
        
    } else {
        [defaultAddress setHidden:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
