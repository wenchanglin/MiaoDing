//
//  ClothesForPayTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/10/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ClothesForPayTableViewCell.h"

@implementation ClothesForPayTableViewCell
{
    UIImageView *clothesImage;
    UILabel *clothesName;
    UILabel *clothesPrice;
    UILabel *clotesCount;
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
    clothesImage = [UIImageView new];
    [contentView addSubview:clothesImage];
    clothesImage.sd_layout
    .leftSpaceToView(contentView,15)
    .topSpaceToView(contentView,19)
    .bottomSpaceToView(contentView,19.5)
    .widthIs(147 / 2);
    [clothesImage setContentMode:UIViewContentModeScaleAspectFit];
    [clothesImage.layer setMasksToBounds:YES];
    
    
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    clothesName.sd_layout
    .leftSpaceToView(clothesImage,13)
    .topSpaceToView(contentView,19)
    .heightIs(20)
    .rightSpaceToView(contentView,20);
    [clothesName setFont:Font_14];
    
    
    clothesPrice = [UILabel new];
    [contentView addSubview:clothesPrice];
    clothesPrice.sd_layout
    .leftSpaceToView(clothesImage,13)
    .bottomSpaceToView(contentView, 19.5)
    .heightIs(15)
    .widthIs(100);
    [clothesPrice setFont:Font_12];
    
    
    _upButton = [UIButton new];
    [contentView addSubview:_upButton];
    _upButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .bottomSpaceToView(contentView, 19.5)
    .heightIs(25)
    .widthIs(40);
    [_upButton setTitle:@"+" forState:UIControlStateNormal];
    [_upButton.layer setBorderWidth:1];
    [_upButton.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
    [_upButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_upButton.layer setCornerRadius:3];
    [_upButton.layer setMasksToBounds:YES];
    
    clotesCount = [UILabel new];
    [contentView addSubview:clotesCount];
    clotesCount.sd_layout
    .rightSpaceToView(_upButton, 0)
    .bottomSpaceToView(contentView, 19.5)
    .heightIs(25)
    .widthIs(40);
    [clotesCount setFont:Font_14];
    [clotesCount setTextAlignment:NSTextAlignmentCenter];
    
    
    _cutButton = [UIButton new];
    [contentView addSubview:_cutButton];
    _cutButton.sd_layout
    .rightSpaceToView(clotesCount,0)
    .bottomSpaceToView(contentView, 19.5)
    .heightIs(25)
    .widthIs(40);
    [_cutButton setTitle:@"-" forState:UIControlStateNormal];
    [_cutButton.layer setBorderWidth:1];
    [_cutButton.layer setCornerRadius:3];
    [_cutButton.layer setMasksToBounds:YES];
    [_cutButton.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
    [_cutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
   

}

-(void)setModel:(ClothesFroPay *)model
{
    _model = model;
    [clothesImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.clothesImage]]];
    [clothesName setText:model.clothesName];
    [clothesPrice setText:[NSString stringWithFormat:@"￥%@",model.clothesPrice]];
    [clotesCount setText:[NSString stringWithFormat:@"%@",model.clothesCount]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
