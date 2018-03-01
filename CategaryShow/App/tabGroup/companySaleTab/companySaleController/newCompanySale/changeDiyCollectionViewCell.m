//
//  changeDiyCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/26.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "changeDiyCollectionViewCell.h"

@implementation changeDiyCollectionViewCell
{
    UIImageView *bgView;
    
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *tagLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self setUI];
        
        
        
    }
    return self;
}

-(void)setUI
{
    UIView *contentView = self.contentView;
    bgView = [UIImageView new];
    [contentView addSubview:bgView];
    
    bgView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .bottomEqualToView(contentView);

    [bgView setImage:[UIImage imageNamed:@"kapian"]];
    
    imgView = [UIImageView new];
    [bgView addSubview:imgView];
    imgView.sd_layout
    .leftSpaceToView(bgView,5)
    .topSpaceToView(bgView, 5)
    .rightSpaceToView(bgView, 5)
    .bottomSpaceToView(bgView, 60);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [imgView.layer setMasksToBounds:YES];
    
    titleLabel = [UILabel new];
    [bgView addSubview:titleLabel];
    titleLabel.sd_layout
    .leftSpaceToView(bgView, 12)
    .topSpaceToView(imgView, 15)
    .heightIs(15)
    .rightSpaceToView(bgView, 12);
    [titleLabel setFont:Font_13];
    
    
    tagLabel = [UILabel new];
    [bgView addSubview:tagLabel];
    tagLabel.sd_layout
    .leftSpaceToView(bgView, 12)
    .topSpaceToView(titleLabel, 7)
    .heightIs(12)
    .rightSpaceToView(bgView, 12);
    [tagLabel setFont:[UIFont systemFontOfSize:10]];
    [tagLabel setTextColor:[UIColor lightGrayColor]];
}

-(void)setModel:(chageDiyModel *)model
{
     UIView *contentView = self.contentView;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.imageAvater]]];
    [titleLabel setText:model.name];
    [tagLabel setText:model.sub_name];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
   
   
    
}


@end
