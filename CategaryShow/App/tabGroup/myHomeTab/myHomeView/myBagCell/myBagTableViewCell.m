//
//  myBagTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/18.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "myBagTableViewCell.h"
#import "myBagModel.h"
@implementation myBagTableViewCell
{
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesPrice;
    UILabel *clothesCount;
    UIButton *noChoose;
    UIButton *haveChoose;
    UILabel *haveSizeOrDing;
    UILabel *tempClothesCount;
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
    noChoose = [UIButton new];
    [contentView addSubview:noChoose];
    noChoose.sd_layout
    .leftSpaceToView(contentView,10)
    .centerYEqualToView(contentView)
    .heightIs(16)
    .widthIs(16);
    [noChoose.layer setCornerRadius:8];
    [noChoose.layer setMasksToBounds:YES];
    
    
    [noChoose addTarget:self action:@selector(chooseClck) forControlEvents:UIControlEventTouchUpInside];
    
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(noChoose,10)
    .centerYEqualToView(contentView)
    .heightIs(80)
    .widthIs(80);
    [clothesImg setContentMode:UIViewContentModeScaleAspectFill];
    [clothesImg.layer setMasksToBounds:YES];
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    
    clothesName.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .topSpaceToView(contentView,25)
    .heightIs(15)
    .widthIs(160);
    [clothesName setFont:Font_14];
    
    haveSizeOrDing = [UILabel new];
    [haveSizeOrDing setTextColor:[UIColor grayColor]];
    [haveSizeOrDing setFont:[UIFont systemFontOfSize:12]];
    [contentView addSubview:haveSizeOrDing];
    
    haveSizeOrDing.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .topSpaceToView(clothesName,5)
    .heightIs(15)
    .widthIs(180);
    
    _moreLabel =[UILabel new];
    _moreLabel.text = @"点击查看更多配件信息";
    [_moreLabel yb_addAttributeTapActionWithStrings:@[_moreLabel.text] delegate:self];
    [_moreLabel setTextColor:[UIColor grayColor]];
    [_moreLabel setFont:[UIFont systemFontOfSize:12]];
    [contentView addSubview:_moreLabel];
    _moreLabel.sd_layout.topSpaceToView(haveSizeOrDing, 2).leftSpaceToView(clothesImg, 13.5).heightIs(15).widthIs(180);
    
    clothesPrice = [UILabel new];
    [contentView addSubview:clothesPrice];
    clothesPrice.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .topSpaceToView(_moreLabel,5)
    .widthIs(180)
    .heightIs(15);
    [clothesPrice setFont:Font_12];
    
    clothesCount = [UILabel new];
    [contentView addSubview:clothesCount];
    clothesCount.sd_layout
    .rightSpaceToView(contentView, 29)
    .topSpaceToView(_moreLabel,5)
    .widthIs(40)
    .heightIs(15);
    [clothesCount setFont:[UIFont systemFontOfSize:16]];
    [clothesCount setTextAlignment:NSTextAlignmentRight];
    
    
    
    _cutCount = [UIButton new];
    [contentView addSubview:_cutCount];
    
    _cutCount.sd_layout
    .leftSpaceToView(clothesImg,16)
    .topSpaceToView(_moreLabel,4)
    .heightIs(25)
    .widthIs(55);
    [_cutCount setTitle:@"-" forState:UIControlStateNormal];
    [_cutCount.layer setBorderWidth:1];
    [_cutCount.layer setCornerRadius:3];
    [_cutCount.layer setMasksToBounds:YES];
    [_cutCount.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
    
    [_cutCount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    
    tempClothesCount = [UILabel new];
    [contentView addSubview:tempClothesCount];
    tempClothesCount.sd_layout
    .leftSpaceToView(_cutCount,0)
    .topSpaceToView(_moreLabel,5)
    .heightIs(25)
    .widthIs(55);
    [tempClothesCount setFont:[UIFont systemFontOfSize:16]];
    [tempClothesCount setTextAlignment:NSTextAlignmentCenter];
    [tempClothesCount setHidden:YES];
    
    _addCount = [UIButton new];
    [contentView addSubview:_addCount];
    
    _addCount.sd_layout
    .leftSpaceToView(tempClothesCount, 0)
    .topSpaceToView(_moreLabel,4)
    .heightIs(25)
    .widthIs(55);
    [_addCount setTitle:@"+" forState:UIControlStateNormal];
    
    [_addCount.layer setCornerRadius:3];
    [_addCount.layer setMasksToBounds:YES];
    [_addCount.layer setBorderWidth:1];
    [_addCount.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
    [_addCount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _lineView = [UIView new];
    [contentView addSubview:_lineView];
    
    _lineView.sd_layout
    .leftSpaceToView(contentView, 10)
    .rightEqualToView(contentView)
    .bottomEqualToView(contentView)
    .heightIs(1);
    [_lineView setBackgroundColor:getUIColor(Color_background)];
    
}

-(void)chooseClck
{
    if ([_delegate respondsToSelector:@selector(clickButton:)]) {
        [_delegate clickButton:self.tag];
    }
}
-(void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(clickMoreLabel:)]) {
        [self.delegate clickMoreLabel:self.tag-10];
    }
}
-(void)setModel:(myBagModel *)model
{
    _model = model;
    if ([model.ifChoose isEqualToString:@"yes"]) {
        [noChoose setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    } else {
        [noChoose setBackgroundImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
    }
    [haveSizeOrDing setText:model.sizeOrDing];
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.goods_img]]];
    [clothesName setText:model.goods_name];
    
    [clothesPrice setText:[NSString stringWithFormat:@"¥%@",model.price]];
    [clothesCount setText:[NSString stringWithFormat:@"×%@", @(model.goods_num)]];
    [tempClothesCount setText:[NSString stringWithFormat:@"%@",@(model.goods_num)]];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_updateIfOrNot) {
        [tempClothesCount setHidden:NO];
        [clothesCount setHidden:YES];
        [clothesPrice setHidden:YES];
    } else {
        [tempClothesCount setHidden:YES];
        [clothesCount setHidden:NO];
        [clothesPrice setHidden:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
