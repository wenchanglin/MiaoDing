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
        
        _titlePay = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 20)];
        [_titlePay setFont:Font_14];
        [self.contentView addSubview:_titlePay];
        
        _detailPay = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 115, 20)];
        [_detailPay setFont:Font_14];
        [_detailPay setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_detailPay];
        
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
