//
//  waitForPayCollectionCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/22.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "waitForPayCollectionCell.h"
@implementation waitForPayCollectionCell
{
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesCount;
    UILabel *sizeContent;
    UILabel*moreLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
-(void)setUp
{
    UIView *contentView = self.contentView;
    UIView *line1 = [UIView new];
    [contentView addSubview:line1];
    
    line1.sd_layout
    .leftSpaceToView(contentView, 13)
    .topSpaceToView(contentView,5)
    .heightIs(1)
    .widthIs(SCREEN_WIDTH - 13);
    [line1 setBackgroundColor:getUIColor(Color_myOrderLine)];
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(line1,5)
    .heightIs(70)
    .widthIs(70);
    [clothesImg setContentMode:UIViewContentModeScaleAspectFit];
    [clothesImg.layer setMasksToBounds:YES];
    
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    clothesName.sd_layout
    .leftSpaceToView(clothesImg, 15)
    .topSpaceToView(line1,10)
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
    
    moreLabel =[UILabel new];
    moreLabel.text = @"点击查看更多配件信息";
    [moreLabel yb_addAttributeTapActionWithStrings:@[moreLabel.text] delegate:self];
    [moreLabel setTextColor:[UIColor grayColor]];
    [moreLabel setFont:[UIFont systemFontOfSize:12]];
    [contentView addSubview:moreLabel];
    moreLabel.sd_layout.topSpaceToView(sizeContent, 2).leftSpaceToView(clothesImg, 15).heightIs(15).widthIs(180);
    
    clothesCount = [UILabel new];
    [contentView addSubview:clothesCount];
    clothesCount.sd_layout
    .leftSpaceToView(clothesImg, 15)
    .topSpaceToView(moreLabel, 2)
    .widthIs(SCREEN_WIDTH - 200)
    .heightIs(15);
    [clothesCount setFont:Font_14];
}
-(void)setModel:(childOrdersModel *)model
{
    _model=model;
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,_model.img_info]]];
    [clothesName setText:_model.goods_name];
    [clothesCount setText:[NSString stringWithFormat:@"共%@件商品",@(_model.goods_num)]];
    [sizeContent setText:_model.sizeOrDing];
}
-(void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(clickMineOrderListMoreLabel:)]) {
        [self.delegate clickMineOrderListMoreLabel:index];
    }
}
@end
