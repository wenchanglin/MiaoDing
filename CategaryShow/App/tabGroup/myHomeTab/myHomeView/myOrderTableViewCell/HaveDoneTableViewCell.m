//
//  HaveDoneTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/29.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "HaveDoneTableViewCell.h"

@implementation HaveDoneTableViewCell
{
    UILabel *dingNumber;
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesCount;
    UILabel *clothesStatus;
    UILabel *sizeContent;
    UILabel *clothesPrice;
    
    UILabel *haveDone;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    
    return self;
}


-(void)setUp
{
    UIView *contentView = self.contentView;
    dingNumber = [UILabel new];
    [contentView addSubview:dingNumber];
    
    dingNumber.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 8)
    .widthIs(contentView.frame.size.width - 100)
    .heightIs(20);
    [dingNumber setFont:Font_12];
    
    clothesStatus = [UILabel new];
    [contentView addSubview:clothesStatus];
    
    clothesStatus.sd_layout
    .rightSpaceToView(contentView,26)
    .topSpaceToView(contentView, 8)
    .heightIs(20)
    .widthIs(80);
    [clothesStatus setFont:Font_12];
    [clothesStatus setTextAlignment:NSTextAlignmentRight];
    
    
    
    UIView *line1 = [UIView new];
    [contentView addSubview:line1];
    
    line1.sd_layout
    .leftSpaceToView(contentView, 13)
    .topSpaceToView(contentView,36.5)
    .heightIs(1)
    .widthIs(SCREEN_WIDTH - 13);
    [line1 setBackgroundColor:getUIColor(Color_myOrderLine)];
    
    
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(line1,15)
    .heightIs(70)
    .widthIs(70);
    [clothesImg setContentMode:UIViewContentModeScaleAspectFit];
    [clothesImg.layer setMasksToBounds:YES];
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    
    clothesName.sd_layout
    .leftSpaceToView(clothesImg, 15)
    .topSpaceToView(line1,15)
    .widthIs(SCREEN_WIDTH - 120)
    .heightIs(20);
    [clothesName setFont:Font_14];
    
    sizeContent = [UILabel new];
    [contentView addSubview:sizeContent];
    sizeContent.sd_layout
    .leftSpaceToView(clothesImg, 15)
    .topSpaceToView(clothesName,2)
    .widthIs(SCREEN_WIDTH - 120)
    .heightIs(15);
    [sizeContent setFont:[UIFont systemFontOfSize:12]];
    [sizeContent setTextColor:getUIColor(ColorOrderGray)];
    
    clothesPrice = [UILabel new];
    [contentView addSubview:clothesPrice];
    
    clothesPrice.sd_layout
    .leftSpaceToView(clothesImg, 15)
    .topSpaceToView(sizeContent, 15)
    .widthIs(SCREEN_WIDTH - 200)
    .heightIs(15);
    [clothesPrice setFont:Font_12];
    
    clothesCount = [UILabel new];
    [contentView addSubview:clothesCount];
    clothesCount.sd_layout
    .rightSpaceToView(contentView,26)
    .topSpaceToView(sizeContent, 10)
    .widthIs(100)
    .heightIs(15);
    [clothesCount setFont:[UIFont systemFontOfSize:11.5]];
    [clothesCount setTextColor:getUIColor(Clolor_myOrderClothesCount)];
    [clothesCount setTextAlignment:NSTextAlignmentRight];
    
    
    
    UIView *line2 = [UIView new];
    [contentView addSubview:line2];
    
    line2.sd_layout
    .leftSpaceToView(contentView, 13)
    .topSpaceToView(contentView , (364 - 88) / 2)
    .heightIs(1)
    .widthIs(SCREEN_WIDTH - 13);
    [line2 setBackgroundColor:getUIColor(Color_myOrderLine)];
    
    
    _commendBtn = [UIButton new];
    [contentView addSubview:_commendBtn];
    
    _commendBtn.sd_layout
    .rightSpaceToView(contentView, 13)
    .topSpaceToView(line2, 7)
    .widthIs(70)
    .heightIs(30);
    [_commendBtn.layer setCornerRadius:1];
    [_commendBtn.layer setMasksToBounds:YES];
    [_commendBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_commendBtn.layer setBorderWidth:1];
    [_commendBtn.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    
    [_commendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_commendBtn setTitle:@"立即评论" forState:UIControlStateNormal];
    
    haveDone = [UILabel new];
    [contentView addSubview:haveDone];
    
    haveDone.sd_layout
    .rightSpaceToView(contentView, 13)
    .topSpaceToView(line2, 7)
    .widthIs(70)
    .heightIs(30);
    [haveDone.layer setCornerRadius:1];
    [haveDone.layer setMasksToBounds:YES];
    [haveDone.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [haveDone.layer setBorderWidth:1];
    [haveDone setFont:[UIFont systemFontOfSize:12.5]];
    [haveDone setText:@"已完成"];
    [haveDone setTextAlignment:NSTextAlignmentCenter];
}

-(void)setModel:(orderModel *)model
{
    _model = model;
    [dingNumber setText: [NSString stringWithFormat:@"订单编号: %@", _model.number]];
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,_model.clothesImg]]];
    [clothesName setText:_model.clothesName];
    [clothesCount setText:[NSString stringWithFormat:@"共%@件商品",_model.clothesCount]];
    [clothesStatus setText:_model.clothesBuyStatus];
    [clothesPrice setText:[NSString stringWithFormat:@"¥%@", _model.clothesPrice]];
    [sizeContent setText:model.sizeContnt];
    
    if (model.ifCommend) {
        [_commendBtn setHidden:NO];
        [haveDone setHidden:YES];
    } else {
        [_commendBtn setHidden:YES];
        [haveDone setHidden:NO];
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
