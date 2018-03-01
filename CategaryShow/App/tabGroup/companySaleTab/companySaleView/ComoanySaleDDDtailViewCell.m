//
//  ComoanySaleFirstTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ComoanySaleDDDtailViewCell.h"
#import "ClothDetailModel.h"
@implementation ComoanySaleDDDtailViewCell

{
    UILabel *titleLabel;
    UILabel *detailLabel;
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
    .centerYEqualToView(contentView)
    .widthIs(60)
    .autoHeightRatio(0);
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:Font_14];
    
    detailLabel = [UILabel new];
    [contentView addSubview:detailLabel];
    
    detailLabel.sd_layout
    .leftSpaceToView(titleLabel,5)
    .centerYEqualToView(contentView)
    .widthIs(contentView.frame.size.width - 85)
    .autoHeightRatio(0);
    [detailLabel setFont:[UIFont systemFontOfSize:14]];
    [detailLabel setNumberOfLines:0];
    [self setupAutoHeightWithBottomViewsArray:[NSArray arrayWithObjects:titleLabel,detailLabel, nil] bottomMargin:10];
    
}

-(void)setModel:(ClothDetailModel *)model
{
    _model = model;
    
    if (![model.detailName isEqual:[NSNull null]]) {
        [titleLabel setText:[NSString stringWithFormat:@"%@",model.detailName]];
        [detailLabel setText:model.detailContent];

    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
