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
    [_titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
    [contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(35);
    }];
    
    _headImage = [UIImageView new];
    [contentView addSubview:_headImage];
    _headImage.sd_layout
    .rightSpaceToView (contentView, 12)
    .centerYEqualToView(contentView)
    .widthIs(60)
    .heightIs(60);
    [_headImage.layer setCornerRadius:30];
    [_headImage.layer setMasksToBounds:YES];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
