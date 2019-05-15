//
//  BagDingTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/2.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BagDingTableViewCell.h"

@implementation BagDingTableViewCell


{
    UILabel *titleLabel;
    
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
    titleLabel= [UILabel new];
    UIView *contentView = self.contentView;
    [contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView,10)
    .rightSpaceToView(contentView, 20)
    .autoHeightRatio(0);
    
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self setupAutoHeightWithBottomView:titleLabel bottomMargin:0];
    
    
}

-(void)setModel:(ClothDetailModel *)model
{
    _model = model;
    [titleLabel setText:[NSString stringWithFormat:@"%@",model.detailName]];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
