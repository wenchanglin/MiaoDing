//
//  FirstSectionTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/16.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "FirstSectionTableViewCell.h"

@implementation FirstSectionTableViewCell
{
    UILabel *labelInt;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        labelInt = [[UILabel alloc] initWithFrame:CGRectZero];
        _vipCount = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_vipCount];
        [self.contentView addSubview:labelInt];
        
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [labelInt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(24);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
    }];
    [labelInt setFont:[UIFont systemFontOfSize:20]];
    
    [labelInt setText:@"我目前的成长值："];
    
    [_vipCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelInt.mas_right).with.offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
    }];
    [_vipCount setTextColor:getUIColor(COLOR_VipLeft)];
    [_vipCount setFont:[UIFont systemFontOfSize:22]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
