//
//  MeasurePickTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MeasurePickTableViewCell.h"
#import "MeasureLabelAndTextFieldModel.h"
@implementation MeasurePickTableViewCell
{
    UILabel *titleName;
    UILabel *detailLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIView *contentView = self.contentView;
    titleName = [UILabel new];
    [contentView addSubview:titleName];
    
    titleName.sd_layout
    .leftSpaceToView(contentView, 28)
    .topSpaceToView(contentView, 15)
    .widthIs(80)
    .bottomSpaceToView(contentView, 15);
    [titleName setFont:[UIFont systemFontOfSize:15]];
    [titleName setTextColor:getUIColor(Color_measureTableTitle)];
    
    detailLabel = [UILabel new];
    [contentView addSubview:detailLabel];
    [detailLabel setTextColor:getUIColor(Color_WearClothesPlaceHolder)];
    detailLabel.sd_layout
    .leftSpaceToView(titleName, 20)
    .centerYEqualToView(contentView)
    .widthIs(contentView.frame.size.width - 200)
    .heightRatioToView(titleName,1);
    [detailLabel setFont:[UIFont systemFontOfSize:14]];
}


-(void)setModel:(MeasureLabelAndTextFieldModel *)model
{
    _model = model;
    [titleName setText:model.titleName];
    [detailLabel setText:model.placeHolder];
    
    
    if ([[model.placeHolder substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"请选择"]) {
        [detailLabel setTextColor:getUIColor(Color_WearClothesPlaceHolder)];
    } else {
        [detailLabel setTextColor:[UIColor blackColor]];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
