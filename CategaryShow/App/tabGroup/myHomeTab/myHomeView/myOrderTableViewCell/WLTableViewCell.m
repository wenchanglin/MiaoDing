//
//  WLTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "WLTableViewCell.h"

@implementation WLTableViewCell
{
    UILabel *contentLabel;
    UILabel *timeLable;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    UIView *contentView = self.contentView;
    
    UIView *circle = [UIView new];
    [contentView addSubview:circle];
    circle.sd_layout
    .leftSpaceToView(contentView, 28)
    .centerYEqualToView(contentView)
    .widthIs(10)
    .heightIs(10);
    [circle.layer setCornerRadius:5];
    [circle.layer setMasksToBounds:YES];
    [circle setBackgroundColor:[UIColor lightGrayColor]];
    
    _topLine = [UIView new];
    [contentView addSubview:_topLine];
    _topLine.sd_layout
    .topEqualToView(contentView)
    .centerXEqualToView(circle)
    .bottomEqualToView(circle)
    .widthIs(1);
    [_topLine setBackgroundColor:[UIColor lightGrayColor]];
    
    _downLine = [UIView new];
    [contentView addSubview:_downLine];
    _downLine.sd_layout
    .topEqualToView(circle)
    .centerXEqualToView(circle)
    .bottomEqualToView(contentView)
    .widthIs(1);
    [_downLine setBackgroundColor:[UIColor lightGrayColor]];
    
    
    timeLable = [UILabel new];
    [contentView addSubview:timeLable];
    timeLable.sd_layout
    .leftSpaceToView(circle, 15)
    .topSpaceToView(contentView, 12)
    .rightSpaceToView (contentView, 10)
    .heightIs(15);
    [timeLable setTextColor:[UIColor lightGrayColor]];
    [timeLable setFont:[UIFont systemFontOfSize:12]];
    
    contentLabel = [UILabel new];
    [contentView addSubview:contentLabel];
    contentLabel.sd_layout
    .leftSpaceToView(circle,15)
    .topSpaceToView(timeLable, 5)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    [contentLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    [self setupAutoHeightWithBottomView:contentLabel bottomMargin:12];
}

-(void)setModel:(wuLiuModel *)model
{
    _model = model;
    [contentLabel setText:model.context];
    [timeLable setText:model.time];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
