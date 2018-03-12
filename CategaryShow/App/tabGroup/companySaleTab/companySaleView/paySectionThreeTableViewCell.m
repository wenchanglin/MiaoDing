//
//  paySectionThreeTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "paySectionThreeTableViewCell.h"

@implementation paySectionThreeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titlePay = [[UILabel alloc] init];
        [_titlePay setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
        _titlePay.textColor = [UIColor colorWithHexString:@"#222222"];
        [self.contentView addSubview:_titlePay];
        [_titlePay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        _detailPay = [[UILabel alloc] init];
        [_detailPay setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:16]];
        _detailPay.textColor = [UIColor colorWithHexString:@"#222222"];
        [_detailPay setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_detailPay];
        [_detailPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
