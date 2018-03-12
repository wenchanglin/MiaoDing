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
    UILabel * clothesContent;
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
    .leftSpaceToView(contentView,12)
    .topSpaceToView(contentView,12)
    .bottomSpaceToView(contentView,12)
    .widthIs(75);
    [clothesImage setContentMode:UIViewContentModeScaleAspectFill];
    [clothesImage.layer setMasksToBounds:YES];
    
    
    clothesName = [UILabel new];
    clothesName.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    [contentView addSubview:clothesName];
    clothesName.sd_layout
    .leftSpaceToView(clothesImage,12)
    .topSpaceToView(contentView,12)
    .heightIs(20)
    .rightSpaceToView(contentView,20);
    [clothesName setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
    
    clothesContent = [UILabel new];
    clothesContent.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    clothesContent.textColor = [UIColor colorWithHexString:@"#6A6A6A"];
    [contentView addSubview:clothesContent];
    clothesContent.sd_layout.leftSpaceToView(clothesImage, 12).topSpaceToView(clothesName, 5).heightIs(17).rightSpaceToView(contentView, 20);
    
    clothesPrice = [UILabel new];
    clothesPrice.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    [contentView addSubview:clothesPrice];
    clothesPrice.sd_layout
    .leftSpaceToView(clothesImage,12)
    .bottomSpaceToView(contentView, 14)
    .heightIs(15)
    .widthIs(120);
    [clothesPrice setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    
    
    _upButton = [UIButton new];
    [contentView addSubview:_upButton];
    _upButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .bottomSpaceToView(contentView, 14)
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
    .bottomSpaceToView(contentView, 14)
    .heightIs(25)
    .widthIs(40);
    [clotesCount setFont:Font_14];
    [clotesCount setTextAlignment:NSTextAlignmentCenter];
    
    
    _cutButton = [UIButton new];
    [contentView addSubview:_cutButton];
    _cutButton.sd_layout
    .rightSpaceToView(clotesCount,0)
    .bottomSpaceToView(contentView, 14)
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
    if([model.clotheType integerValue]==1)
    {
        clothesContent.text = @"定制款";
    }
    else if ([model.clotheType integerValue]==2)
    {
        clothesContent.text = model.sizeContent;
    }
    [clothesPrice setText:[NSString stringWithFormat:@"￥%@",model.clothesPrice]];
    [clotesCount setText:[NSString stringWithFormat:@"%@",model.clothesCount]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
