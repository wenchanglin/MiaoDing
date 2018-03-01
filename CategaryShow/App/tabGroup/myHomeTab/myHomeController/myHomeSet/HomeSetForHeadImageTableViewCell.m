//
//  HomeSetForHeadImageTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "HomeSetForHeadImageTableViewCell.h"

@implementation HomeSetForHeadImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    _titleLabel = [UILabel new];
    [contentView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView (contentView, 15)
    .centerYEqualToView(contentView)
    .widthIs(80)
    .heightIs(20);
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    _headImage = [UIImageView new];
    [contentView addSubview:_headImage];
    _headImage.sd_layout
    .rightSpaceToView (contentView, 15)
    .centerYEqualToView(contentView)
    .widthIs(34)
    .heightIs(34);
    [_headImage.layer setCornerRadius:17];
    [_headImage.layer setMasksToBounds:YES];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
