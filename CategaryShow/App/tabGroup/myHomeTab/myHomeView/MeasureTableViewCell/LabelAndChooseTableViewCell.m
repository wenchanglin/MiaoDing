//
//  LabelAndChooseTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "LabelAndChooseTableViewCell.h"

#import "MeasureLabelAndTextFieldModel.h"

@implementation LabelAndChooseTableViewCell

{
    UILabel *titleName;
    FSComboListView *comboListView;
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
    [titleName setFont:[UIFont systemFontOfSize:18]];
    [titleName setTextColor:getUIColor(Color_measureTableTitle)];
    
    comboListView = [[FSComboListView alloc] initWithValues:@[@"Value 1",
                                                                               @"Value 2",
                                                                               @"Value 3",
                                                                               @"Value 4",
                                                                               @"Value 5"]
                                                                       frame:CGRectMake(118, 5, 200, 30)];
    comboListView.delegate = self;
    comboListView.tintColor = [UIColor darkGrayColor];
    comboListView.textColor = [UIColor darkGrayColor];


    
    [self addSubview:comboListView];
    
}


-(void)setModel:(MeasureLabelAndTextFieldModel *)model
{
    _model = model;
    [titleName setText:model.titleName];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
