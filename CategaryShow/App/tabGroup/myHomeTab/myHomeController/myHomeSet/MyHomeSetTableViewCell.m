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
    _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [contentView addSubview:_titleLabel];
    _titleLabel.sd_layout
    .leftSpaceToView (contentView, 12)
    .centerYEqualToView(contentView)
    .widthIs(80)
    .heightIs(20);
    [_titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
    
    _detaiLabel = [UILabel new];
    [contentView addSubview:_detaiLabel];
    _detaiLabel.sd_layout
    .rightSpaceToView (contentView, 12)
    .centerYEqualToView(contentView)
    .widthIs(120)
    .heightIs(20);
    [_detaiLabel setTextAlignment:NSTextAlignmentRight];
    _detaiLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
