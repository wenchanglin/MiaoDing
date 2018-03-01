//
//  giftCardTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "giftCardTableViewCell.h"

@implementation giftCardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _lastMoney = [UILabel new];
        [self.contentView addSubview:_lastMoney];
        
        _chooseImage = [UIButton new];
        [self.contentView addSubview:_chooseImage];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _chooseImage.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .widthIs(14)
    .heightIs(14);
    
    _lastMoney.sd_layout
    .leftSpaceToView(_chooseImage, 10)
    .centerYEqualToView(self.contentView)
    .heightIs(16)
    .rightSpaceToView(self.contentView, 10);
    
    [_lastMoney setFont:Font_14];
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
