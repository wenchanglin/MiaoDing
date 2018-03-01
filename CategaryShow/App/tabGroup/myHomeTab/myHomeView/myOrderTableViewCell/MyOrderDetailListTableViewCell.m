//
//  MyOrderDetailListTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MyOrderDetailListTableViewCell.h"

@implementation MyOrderDetailListTableViewCell
{
    UIImageView *clothesImg;
    UILabel *clothesName;
    UILabel *clothesPrice;
    UILabel *clothesCount;
    UILabel *sizeContent;
    
    
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
    
    
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    clothesImg.sd_layout
    .leftSpaceToView(contentView,15)
    .centerYEqualToView(contentView)
    .heightIs(74)
    .widthIs(74);
    [clothesImg setContentMode:UIViewContentModeScaleAspectFit];
    [clothesImg.layer setMasksToBounds:YES];
    
    
    clothesName = [UILabel new];
    [contentView addSubview:clothesName];
    
    clothesName.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .topSpaceToView(contentView,20)
    .heightIs(15)
    .widthIs(200);
    [clothesName setFont:Font_14];
    
    
    
    sizeContent = [UILabel new];
    [contentView addSubview:sizeContent];
    
    sizeContent.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .topSpaceToView(clothesName,5)
    .heightIs(15)
    .widthIs(200);
    [sizeContent setFont:[UIFont systemFontOfSize:12]];
    [sizeContent setTextColor:getUIColor(ColorOrderGray)];

    
    clothesPrice = [UILabel new];
    [contentView addSubview:clothesPrice];
    clothesPrice.sd_layout
    .leftSpaceToView(clothesImg,13.5)
    .bottomSpaceToView(contentView,20)
    .widthIs(200)
    .heightIs(15);
    [clothesPrice setFont:Font_12];
    
    clothesCount = [UILabel new];
    [contentView addSubview:clothesCount];
    clothesCount.sd_layout
    .rightSpaceToView(contentView, 29)
    .bottomSpaceToView(contentView, 20)
    .widthIs(40)
    .heightIs(15);
    [clothesCount setFont:Font_14];
    [clothesCount setTextAlignment:NSTextAlignmentRight];

}

-(void)setModel:(myBagModel *)model
{
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.clothesImg]]];
    [clothesName setText:model.clothesName];
    [clothesPrice setText:[NSString stringWithFormat:@"¥%@",model.clothesPrice]];
    [clothesCount setText:[NSString stringWithFormat:@"×%@", model.clothesCount]];
    [sizeContent setText:model.sizeOrDing];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
