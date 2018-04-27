//
//  addressAddTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/10.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "addressAddTableViewCell.h"

@implementation addressAddTableViewCell
{
    UILabel *userName;
    UILabel *userPhone;
    UILabel *userAddress;
    UIButton *chooseBtn;
    UILabel *chooseTitle;
    UIButton *deleteBtn;
    UIButton *updateBtn;
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    
    UILabel *nameTitle = [UILabel new];
    [contentView addSubview:nameTitle];
    nameTitle.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 12)
    .widthIs(60)
    .heightIs(15);
    [nameTitle setFont:Font_14];
    [nameTitle setText:@"收货人："];
    
    userName = [UILabel new];
    [contentView addSubview:userName];
    userName.sd_layout
    .leftSpaceToView(nameTitle, 5)
    .topSpaceToView(contentView, 12)
    .widthIs(120)
    .heightIs(15);
    [userName setTextColor:getUIColor(Color_numberWatch)];
    [userName setFont:[UIFont systemFontOfSize:14]];
    
    
    userPhone = [UILabel new];
    [contentView addSubview:userPhone];
    userPhone.sd_layout
    .rightSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 12)
    .widthIs(SCREEN_WIDTH - 165)
    .heightIs(15);
    [userPhone setTextAlignment:NSTextAlignmentRight];
    [userPhone setFont:Font_12];
    
    
    UILabel *addTitle = [UILabel new];
    [contentView addSubview:addTitle];
    addTitle.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(userName, 10)
    .widthIs(60)
    .heightIs(15);
    [addTitle setFont:Font_14];
    [addTitle setText:@"地   址："];
    
    userAddress = [UILabel new];
    [contentView addSubview:userAddress];
    userAddress.sd_layout
    .leftSpaceToView(addTitle, 5)
    .topSpaceToView(userName, 10)
    .widthIs(SCREEN_WIDTH - 30)
    .heightIs(15);
    [userAddress setFont:[UIFont systemFontOfSize:14]];
    [userAddress setTextColor:getUIColor(Color_numberWatch)];
    
    UILabel* lineView = [UILabel new];
    [contentView addSubview:lineView];
    lineView.sd_layout
    .leftEqualToView(contentView)
    .topSpaceToView(userAddress, 12)
    .widthIs(SCREEN_WIDTH)
    .heightIs(1);
    [lineView setBackgroundColor:getUIColor(Color_myOrderBack)];
    
    
    chooseBtn = [UIButton new];
    [contentView addSubview:chooseBtn];
    chooseBtn.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(lineView, 12)
    .widthIs(24)
    .heightIs(24);
    
    
    
    chooseTitle = [UILabel new];
    [contentView addSubview:chooseTitle];
    chooseTitle.sd_layout
    .leftSpaceToView(chooseBtn, 4)
    .topSpaceToView(lineView, 12)
    .widthIs(200)
    .heightIs(24);

    [chooseTitle setFont:[UIFont systemFontOfSize:12]];
    [chooseTitle setTextColor:getUIColor(Color_saveColor)];
    
    
    
    UILabel *update = [UILabel new];
    [contentView addSubview:update];
    [update mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).with.offset(-12);
        make.top.equalTo(lineView.mas_bottom).with.offset(12);
        make.height.equalTo(@24);
    }];
    [update setText:@"编辑"];
    [update setFont:[UIFont systemFontOfSize:12]];
    [update setTextColor:getUIColor(Color_saveColor)];
    
    
    updateBtn = [UIButton new];
    [contentView addSubview:updateBtn];
    updateBtn.sd_layout
    .rightSpaceToView(update, 6)
    .topSpaceToView(lineView, 10)
    .heightIs(28)
    .widthIs(28);
    [updateBtn setImage:[UIImage imageNamed:@"addressUpate"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)setModel:(AddressModel *)model
{
    _model = model;
    userName.text = model.userName;
    userAddress.text = model.userAddress;
    userPhone.text = model.userPhone;
    if ([model.addressDefault isEqualToString:@"1"]) {
        [chooseBtn setImage:[UIImage imageNamed:@"addressChoose"] forState:UIControlStateNormal];
        [chooseTitle setText:@"默认地址"];
    } else {
         [chooseBtn setImage:[UIImage imageNamed:@"addressNoChoose"] forState:UIControlStateNormal];
        [chooseTitle setText:@"设为默认地址"];
        [chooseBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)chooseAction
{
    if ([_delegate respondsToSelector:@selector(clickChooseAddress:)]) {
        [_delegate clickChooseAddress:self.tag - 10];
    }
}

-(void)updateAction
{
    if ([_delegate respondsToSelector:@selector(clickUpdateAddress:)]) {
        [_delegate clickUpdateAddress:self.tag - 10];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
