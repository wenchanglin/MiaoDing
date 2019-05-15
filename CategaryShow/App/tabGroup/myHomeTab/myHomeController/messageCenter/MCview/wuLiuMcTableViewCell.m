
//
//  wuLiuMcTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/6.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "wuLiuMcTableViewCell.h"

@implementation wuLiuMcTableViewCell
{
    UILabel *titleLabel;
    UIImageView *imgContent;
    UILabel *nameContent;
    UILabel *senderContent;
    UILabel *typeLabel;
    
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
    titleLabel = [UILabel new];
    [contentView addSubview:titleLabel];
    
    titleLabel.sd_layout
    .leftSpaceToView(contentView, 20)
    .topEqualToView(contentView)
    .heightIs(33)
    .rightSpaceToView(contentView, 20);
    [titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    UIView *topLine = [UIView new];
    [contentView addSubview:topLine];
    topLine.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 20)
    .heightIs(1)
    .topSpaceToView(titleLabel, 0);
    [topLine setBackgroundColor:getUIColor(Color_background)];
    
    imgContent = [UIImageView new];
    [contentView addSubview:imgContent];
    imgContent.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(topLine, 13)
    .widthIs(75)
    .heightIs(68);
    [imgContent setContentMode:UIViewContentModeScaleAspectFill];
    [imgContent .layer setMasksToBounds:YES];
    
    nameContent = [UILabel new];
    [contentView addSubview:nameContent];
    nameContent.sd_layout
    .leftSpaceToView(imgContent, 12)
    .topSpaceToView(topLine, 35)
    .rightSpaceToView(contentView, 20)
    .heightIs(15);
    [nameContent setFont:[UIFont systemFontOfSize:12]];
    
    typeLabel = [UILabel new];
    [contentView addSubview:typeLabel];
    typeLabel.sd_layout
    .leftSpaceToView(imgContent, 12)
    .topSpaceToView(nameContent, 5)
    .rightSpaceToView(contentView, 20)
    .heightIs(15);
    [typeLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    
    UIView *downLine = [UIView new];
    [contentView addSubview:downLine];
    downLine.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 20)
    .heightIs(1)
    .topSpaceToView(imgContent, 13);
    [downLine setBackgroundColor:getUIColor(Color_background)];
    
    
    senderContent = [UILabel new];
    [contentView addSubview:senderContent];
    senderContent.sd_layout
    .leftSpaceToView(imgContent, 12)
    .topSpaceToView(nameContent, 5)
    .rightSpaceToView(contentView, 20)
    .heightIs(15);
    [senderContent setFont:[UIFont systemFontOfSize:12]];
    
    UILabel *label = [UILabel new];
    [contentView addSubview:label];
    label.sd_layout
    .leftSpaceToView(contentView, 20)
    .rightSpaceToView(contentView, 20)
    .bottomEqualToView(contentView)
    .topSpaceToView(downLine, 0);
    [label setText:@"请您耐心等待,(如有疑问，可联系客服)"];
    [label setFont:[UIFont systemFontOfSize:10]];
    
    
    
}

-(void)setModel:(messageListModel *)model
{
    _model = model;
    [imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.car_img]]];
    [titleLabel setText:[NSString stringWithFormat:@"您的订单:%@", model.re_marks]];
    [senderContent setText:@"配送单位:顺丰快递"];
    [nameContent setText:[NSString stringWithFormat:@"物流单号:%@",model.express_no]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
