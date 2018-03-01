//
//  payConponTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "payConponTableViewCell.h"

@implementation payConponTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _chooseCon = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width - 30, 20)];
        [_chooseCon setFont:Font_14];
        [self.contentView addSubview:_chooseCon];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
