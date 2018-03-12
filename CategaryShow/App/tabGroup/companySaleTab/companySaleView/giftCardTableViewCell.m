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
        [_lastMoney setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
        _lastMoney.textColor = [UIColor colorWithHexString:@"#222222"];
        [self.contentView addSubview:_lastMoney];
        
        _chooseImage = [UIButton new];
        [self.contentView addSubview:_chooseImage];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [_chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.width.mas_equalTo(14);
    }];
    
    [_lastMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chooseImage.mas_right).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
