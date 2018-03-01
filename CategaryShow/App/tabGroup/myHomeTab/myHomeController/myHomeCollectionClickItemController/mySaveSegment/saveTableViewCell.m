//
//  saveTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/7/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "saveTableViewCell.h"

@implementation saveTableViewCell
{
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesDetail;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpview];
        
    }
    return self;
}

-(void)setUpview
{
    UIView *contentView = self.contentView;
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 12)
    .bottomSpaceToView(contentView, 12)
    .widthIs(80);
    [clothesImg setContentMode:UIViewContentModeScaleAspectFill];
    [clothesImg.layer setMasksToBounds:YES];
    
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    clothesName.sd_layout
    .leftSpaceToView(clothesImg, 18)
    .topSpaceToView(contentView, 21)
    .heightIs(20)
    .rightSpaceToView(contentView, 20);
    [clothesName setFont:Font_16];
    
    clothesDetail = [UILabel new];
    [contentView addSubview:clothesDetail];
    clothesDetail.sd_layout
    .leftSpaceToView(clothesImg, 18)
    .bottomSpaceToView(contentView, 21)
    .heightIs(20)
    .rightSpaceToView(contentView, 20);
    [clothesDetail setFont:[UIFont systemFontOfSize:14]];
    [clothesDetail setTextColor:getUIColor(Color_DZClolor)];
  
}

-(void)setModel:(mySavedModel *)model
{
    _model = model;
    
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.clothesImg]]];
    [clothesName setText:model.clothesName];
    [clothesDetail setText:model.subName];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
