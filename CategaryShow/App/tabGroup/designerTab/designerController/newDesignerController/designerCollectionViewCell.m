//
//  designerCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerCollectionViewCell.h"

@implementation designerCollectionViewCell
{
    UIImageView *headImage;
    UILabel *designerName;
    UILabel *designerIntro;
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
    
    headImage = [UIImageView new];
    [contentView addSubview:headImage];
    headImage.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .heightIs(169);
    [headImage setContentMode:UIViewContentModeScaleAspectFill];
    [headImage.layer setMasksToBounds:YES];
    
    
    designerName = [UILabel new];
    [contentView addSubview:designerName];
    designerName.sd_layout
    .leftEqualToView(contentView)
    .topSpaceToView(headImage, 10)
    .rightEqualToView(contentView)
    .heightIs(20);
    [designerName setFont:Font_14];
    
    designerIntro = [UILabel new];
    [contentView addSubview:designerIntro];
    designerIntro.sd_layout
    .leftEqualToView(contentView)
    .topSpaceToView(designerName, 8)
    .rightEqualToView(contentView)
    .heightIs(15);
    [designerIntro setFont:[UIFont systemFontOfSize:11]];
    [designerIntro setTextColor:getUIColor(Color_TKClolor)];
    
    
    
    
}


-(void)setModel:(designerModel *)model
{
    _model = model;
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.designerHead]]];
    [designerName setText:model.designerName];
    [designerIntro setText:model.designerSimpleIntd];
}

@end
