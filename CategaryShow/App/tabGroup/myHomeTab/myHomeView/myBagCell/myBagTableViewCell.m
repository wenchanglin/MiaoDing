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
    .heightIs(30)
    .widthIs(30);
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
    .widthIs(180);
    [clothesName setFont:Font_14];
    
    haveSizeOrDing = [UILabel new];
    [contentView addSubview:haveSizeOrDing];
    
    haveSizeOrDing.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .topSpaceToView(clothesName,5)
    .heightIs(15)
    .widthIs(180);
    [haveSizeOrDing setTextColor:[UIColor grayColor]];
    [haveSizeOrDing setFont:[UIFont systemFontOfSize:12]];
    
    
    
    clothesPrice = [UILabel new];
    [contentView addSubview:clothesPrice];
    clothesPrice.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .bottomSpaceToView(contentView,30)
    .widthIs(180)
    .heightIs(15);
    [clothesPrice setFont:Font_12];
    
    clothesCount = [UILabel new];
    [contentView addSubview:clothesCount];
    
    clothesCount.sd_layout
    .rightSpaceToView(contentView, 29)
    .bottomSpaceToView(contentView,30)
    .widthIs(40)
    .heightIs(15);
    [clothesCount setFont:[UIFont systemFontOfSize:16]];
    [clothesCount setTextAlignment:NSTextAlignmentRight];
    
    
    _cutCount = [UIButton new];
    [contentView addSubview:_cutCount];
    
    _cutCount.sd_layout
    .leftSpaceToView(clothesImg,16)
    .topSpaceToView(clothesName,33)
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
    .topSpaceToView(clothesName, 33)
    .heightIs(25)
    .widthIs(55);
    [tempClothesCount setFont:[UIFont systemFontOfSize:16]];
    [tempClothesCount setTextAlignment:NSTextAlignmentCenter];
    [tempClothesCount setHidden:YES];
    
    _addCount = [UIButton new];
    [contentView addSubview:_addCount];
    
    _addCount.sd_layout
    .leftSpaceToView(tempClothesCount, 0)
    .topSpaceToView(clothesName, 33)
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

-(void)setModel:(myBagModel *)model
{
    _model = model;
    if ([model.ifChoose isEqualToString:@"yes"]) {
        [noChoose setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        
    } else {
        
        [noChoose setImage:[UIImage imageNamed:@"noChoose"] forState:UIControlStateNormal];
    }
    [haveSizeOrDing setText:model.sizeOrDing];
    
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.clothesImg]]];
    
    [clothesName setText:model.clothesName];
    
    [clothesPrice setText:[NSString stringWithFormat:@"¥%@",model.clothesPrice]];
    [clothesCount setText:[NSString stringWithFormat:@"×%@", model.clothesCount]];
    [tempClothesCount setText:model.clothesCount];
    
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
