//
//  DesigherCollectionViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "DesigherCollectionViewCell.h"
#import "designerModel.h"
@implementation DesigherCollectionViewCell
{
    
    UIImageView *clothesImage;
    UIImageView *designerHead;
    UILabel *designerLabel;
    UILabel *designerInto;
    UIView *blowView;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
    .topEqualToView(contentView)
    .centerXEqualToView(contentView);

    
    
    blowView = [UIView new];
    [contentView addSubview:blowView];
    blowView.sd_layout
    .centerXEqualToView(contentView)
    .topSpaceToView(clothesImage, 30)
    .leftEqualToView(clothesImage)
    .rightEqualToView(clothesImage)
    .heightIs(70);
    [blowView.layer setBorderWidth:1.0f];
    [blowView.layer setBorderColor:getUIColor(Color_saveColor).CGColor];
    
    designerHead = [UIImageView new];
    [blowView addSubview:designerHead];
    designerHead.sd_layout
    .leftSpaceToView(blowView, 10)
    .topSpaceToView(blowView, 10)
    .bottomSpaceToView(blowView, 10)
    .widthEqualToHeight(1);
    
    designerHead.sd_cornerRadiusFromHeightRatio = @(0.5);
    
    designerLabel = [UILabel new];
    [blowView addSubview:designerLabel];
    designerLabel.sd_layout
    .leftSpaceToView(designerHead,10)
    .topSpaceToView(blowView,5)
    .rightEqualToView(blowView)
    .autoHeightRatio(0);
    [designerLabel setTextColor:getUIColor(Color_buyColor)];
    [designerLabel setFont:[UIFont systemFontOfSize:16]];
    
    
    designerInto = [UILabel new];
    [blowView addSubview:designerInto];
    designerInto.sd_layout
    .leftSpaceToView(designerHead,10)
    .topSpaceToView(designerLabel,3)
    .rightEqualToView(blowView)
    .bottomSpaceToView(blowView, 5);

    [designerInto setFont:[UIFont systemFontOfSize:14]];
    [designerInto setNumberOfLines:0];
    [designerInto setTextColor:getUIColor(Color_saveColor)];
    UIView *lineView = [UIView new];
    [contentView addSubview:lineView];
    lineView.sd_layout
    .topSpaceToView(clothesImage,0)
    .bottomSpaceToView(blowView, 0)
    .leftSpaceToView(contentView,30)
    .widthIs(1);
    [lineView setBackgroundColor:getUIColor(Color_saveColor)];
    
    UIView *lineView1 = [UIView new];
    [contentView addSubview:lineView1];
    lineView1.sd_layout
    .topSpaceToView(clothesImage,0)
    .bottomSpaceToView(blowView, 0)
    .rightSpaceToView(contentView,30)
    .widthIs(1);
    [lineView1 setBackgroundColor:getUIColor(Color_saveColor)];
    
    _clothesClick = [UIButton new];
    [contentView addSubview:_clothesClick];
    _clothesClick.sd_layout
    .leftEqualToView(clothesImage)
    .rightEqualToView(clothesImage)
    .topEqualToView(clothesImage)
    .bottomEqualToView(clothesImage);
    
    _designerClick = [UIButton new];
    [contentView addSubview:_designerClick];
    _designerClick.sd_layout
    .leftEqualToView(blowView)
    .rightEqualToView(blowView)
    .topEqualToView(blowView)
    .bottomEqualToView(blowView);
    
}

-(void)setModel:(designerModel *)model
{
    _model = model;

    CGSize sizeContent = self.contentView.frame.size;
    UIImage *pic = [UIImage imageNamed:@"BoyClothes1"];
    CGFloat scan = pic.size.width / pic.size.height;
    CGFloat scanScreen = (sizeContent.width)/ (self.frame.size.height - 90);
    
    if (scan > scanScreen) {
        clothesImage.sd_layout
        .widthIs(sizeContent.width )
        .heightIs((sizeContent.width) / pic.size.width * pic.size.height);
        
    } else {
        clothesImage.sd_layout
        .heightIs(self.frame.size.height  - 90)
        .widthIs((self.frame.size.height  - 90) / pic.size.height * pic.size.width);
    }
    
    clothesImage.image = pic;
    
    [designerHead setImage:[UIImage imageNamed:model.avatar]];
    [designerLabel setText:model.uname];
    [designerInto setText:model.introduce];
    
    
    
    
    
    
    
}


@end
