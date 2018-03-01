//
//  MineListNotForCollectionCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MineListNotForCollectionCell.h"

@implementation MineListNotForCollectionCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
        
        
        [self.contentView addSubview:_titleImage];
        
        [self.contentView addSubview:_titleName];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_titleImage.mas_right).with.offset(10);
        make.height.equalTo(@20);
        
    }];
    
    [_titleName setFont:[UIFont systemFontOfSize:14]];
    
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
