//
//  growListTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/16.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "growListTableViewCell.h"

@implementation growListTableViewCell
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *addCountLabel;
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
    
    nameLabel = [UILabel new];
    [contentView addSubview:nameLabel];
    nameLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, 15)
    .heightIs(15)
    .rightSpaceToView(contentView, 100);
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    
    timeLabel = [UILabel new];
    [contentView addSubview:timeLabel];
    timeLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .bottomSpaceToView(contentView, 15)
    .heightIs(15)
    .rightSpaceToView(contentView, 100);
    [timeLabel setFont:[UIFont systemFontOfSize:10]];
    
    
    addCountLabel = [UILabel new];
    [contentView addSubview:addCountLabel];
    addCountLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .heightIs(15)
    .widthIs(100);
    [addCountLabel setTextAlignment:NSTextAlignmentRight];
    [addCountLabel setFont:[UIFont systemFontOfSize:12]];
}

-(void)setModel:(VipGrowModel *)model
{
    _model = model;
    [nameLabel setText:model.type_name];
    [timeLabel setText:model.create_time];
    [addCountLabel setText:model.credit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
