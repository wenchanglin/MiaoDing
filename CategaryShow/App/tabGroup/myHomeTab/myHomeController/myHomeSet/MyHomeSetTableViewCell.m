//
//  MyHomeSetTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MyHomeSetTableViewCell.h"

@implementation MyHomeSetTableViewCell

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
    
    _detaiLabel = [UILabel new];
    [contentView addSubview:_detaiLabel];
    _detaiLabel.sd_layout
    .rightSpaceToView (contentView, 15)
    .centerYEqualToView(contentView)
    .widthIs(120)
    .heightIs(20);
    [_detaiLabel setTextAlignment:NSTextAlignmentRight];
   
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
