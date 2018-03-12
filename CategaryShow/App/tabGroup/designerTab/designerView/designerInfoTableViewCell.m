//
//  designerInfoTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/26.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerInfoTableViewCell.h"

@implementation designerInfoTableViewCell

{
    UIImageView *designerHead;
    UILabel *designerName;
    UILabel *time;
    UILabel *clothesName;
    UIImageView *clothesImg;
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
    
    designerHead = [UIImageView new];
    [contentView addSubview:designerHead];
    
    designerHead.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 20)
    .heightIs(32)
    .widthIs(32);
    [designerHead.layer setCornerRadius:16];
    [designerHead.layer setMasksToBounds:YES];
    
    designerName = [UILabel new];
    [contentView addSubview:designerName];
    designerName.sd_layout
    .leftSpaceToView(designerHead, 8)
    .topSpaceToView(contentView, 20)
    .heightIs(15)
    .widthIs(80);
    [designerName setFont:Font_14];
    
    time = [UILabel new];
    [contentView addSubview:time];
    
    time.sd_layout
    .leftSpaceToView(designerHead, 8)
    .topSpaceToView(designerName, 2)
    .heightIs(15)
    .rightSpaceToView(contentView, 20);
    [time setFont:[UIFont systemFontOfSize:12]];
    [time setTextColor:[UIColor grayColor]];
    
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    
    clothesName.sd_layout
    .leftSpaceToView(designerHead, 8)
    .topSpaceToView(time, 6)
    .heightIs(15)
    .rightSpaceToView(contentView, 20);
    [clothesName setFont:Font_14];
    
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(designerHead, 8)
    .topSpaceToView(clothesName, 5)
    .rightSpaceToView(contentView, 10)
    .bottomSpaceToView(contentView, 10);
    [clothesImg.layer setMasksToBounds:YES];
    [clothesImg setContentMode:UIViewContentModeScaleAspectFill];
    
    
    
    
}

-(void)setModel:(designerModel *)model
{
    
    _model = model;
    
    [designerHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.avatar]]];
    [designerName setText:model.uname];
    [time setText:model.p_time];
    [clothesName setText:model.name];
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img]]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
