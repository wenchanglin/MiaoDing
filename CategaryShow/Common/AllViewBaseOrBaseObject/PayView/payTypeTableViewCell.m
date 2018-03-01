//
//  payTypeTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "payTypeTableViewCell.h"



@implementation payTypeTableViewCell
{
    UIImageView *payTypeImage;
    UILabel *payTypeName;
    UILabel *payTypeRemark;
    UIImageView *payTypeChooseNo;
    UIImageView *payTypeChooseYes;
    NSMutableArray *typeArray;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    UIView *contentView = self.contentView;
    payTypeImage = [UIImageView new];
    [contentView addSubview:payTypeImage];
    payTypeImage.sd_layout
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .widthIs(31)
    .heightIs(31);
    
    payTypeName = [UILabel new];
    [contentView addSubview:payTypeName];
    payTypeName.sd_layout
    .leftSpaceToView(payTypeImage,15)
    .topEqualToView(payTypeImage)
    .widthIs(100)
    .heightIs(15);
    [payTypeName setFont:[UIFont systemFontOfSize:14]];
    
    payTypeRemark = [UILabel new];
    [contentView addSubview:payTypeRemark];
    payTypeRemark.sd_layout
    .leftSpaceToView(payTypeImage,15)
    .bottomEqualToView(payTypeImage)
    .heightIs(15)
    .widthIs(200);
    [payTypeRemark setFont:[UIFont systemFontOfSize:14]];
    [payTypeRemark setTextColor:getUIColor(Color_myBagUpdate)];
    
    
    payTypeChooseNo = [UIImageView new];
    [contentView addSubview:payTypeChooseNo];
    payTypeChooseNo.sd_layout
    .rightSpaceToView(contentView,40)
    .centerYEqualToView(contentView)
    .heightIs(16)
    .widthIs(16);
    [payTypeChooseNo setImage:[UIImage imageNamed:@"noChoose"]];
    
    
    payTypeChooseYes = [UIImageView new];
    [contentView addSubview:payTypeChooseYes];
    payTypeChooseYes.sd_layout
    .rightSpaceToView(contentView,40)
    .centerYEqualToView(contentView)
    .heightIs(16)
    .widthIs(16);
    [payTypeChooseYes setImage:[UIImage imageNamed:@"choose"]];
    
}

-(void)setModel:(payTypeModel *)model
{
    _model = model;
    [payTypeImage setImage:[UIImage imageNamed:model.typeImage]];
    [payTypeRemark setText:model.typeRemark];
    [payTypeName setText:model.typeName];
    if (model.chooseIf) {
        [payTypeChooseYes setHidden:NO];
        [payTypeChooseNo setHidden:YES];
    } else {
        [payTypeChooseYes setHidden:YES];
        [payTypeChooseNo setHidden:NO];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
