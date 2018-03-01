//
//  cashTransactionSuccessTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "cashTransactionSuccessTableViewCell.h"
#import "orderModel.h"
@implementation cashTransactionSuccessTableViewCell
{
    UILabel *dingNumber;
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesCount;
    UILabel *clothesStatus;
    UILabel *clothesPrice;
    UILabel *sizeContent;
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
    

    
    
    _confirm = [UIButton new];
    [contentView addSubview:_confirm];
    
    _confirm.sd_layout
    .rightSpaceToView(contentView, 13)
    .topSpaceToView(line2, 7)
    .widthIs(70)
    .heightIs(30);
    [_confirm.layer setCornerRadius:2];
    [_confirm.layer setMasksToBounds:YES];
    [_confirm setBackgroundColor:[UIColor blackColor]];
    [_confirm.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    [_confirm setTitle:@"确认收货" forState:UIControlStateNormal];
    [_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    _logistics = [UIButton new];
    [contentView addSubview:_logistics];
    
    _logistics.sd_layout
    .rightSpaceToView(_confirm, 10)
    .topSpaceToView(line2, 7)
    .widthIs(70)
    .heightIs(30);
    [_logistics.layer setCornerRadius:2];
    [_logistics.layer setMasksToBounds:YES];
    [_logistics.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_logistics.layer setBorderWidth:1];
    [_logistics.titleLabel setFont:[UIFont systemFontOfSize:12.5]];
    [_logistics setTitle:@"追踪物流" forState:UIControlStateNormal];
    [_logistics setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
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
    [sizeContent setText:_model.sizeContnt];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
