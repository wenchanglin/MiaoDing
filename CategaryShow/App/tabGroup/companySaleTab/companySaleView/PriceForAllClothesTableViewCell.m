//
//  PriceForAllClothesTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "PriceForAllClothesTableViewCell.h"

@implementation PriceForAllClothesTableViewCell
{
    UILabel *titleName;
    UILabel *contentDetail;
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
    titleName = [UILabel new];
    [contentView addSubview:titleName];
    titleName.sd_layout
    .leftSpaceToView(contentView, 20)
    .centerYEqualToView(contentView)
    .heightIs(20)
    .widthIs(100);
    [titleName setFont:[UIFont systemFontOfSize:14]];
    
    
    contentDetail = [UILabel new];
    [contentView addSubview:contentDetail];
    contentDetail.sd_layout
    .rightSpaceToView(contentView, 20)
    .centerYEqualToView(contentView)
    .heightIs(20)
    .widthIs(100);
    [contentDetail setFont:[UIFont systemFontOfSize:14]];
    [contentDetail setTextAlignment:NSTextAlignmentRight];
    
}

-(void)setModel:(priceModel *)model
{
    _model = model;
    [titleName setText:model.title];
    [contentDetail setText:[NSString stringWithFormat:@"¥%@",model.content]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
