//
//  DiyHeadCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/11.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "DiyHeadCell.h"

@implementation DiyHeadCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _firstView = [UIView new];
    _firstView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.contentView addSubview:_firstView];
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    _leftLabel= [UILabel new];
    _leftLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    _leftLabel.font= [UIFont fontWithName:@"PingFangSC-Light" size:13];
    [self.contentView addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(18);
    }];
    _rightLabel = [UILabel new];
    _rightLabel.textColor = [UIColor colorWithHexString:@"#A6A6A6"];
    _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftLabel.mas_centerY);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(-12);
    }];
    _endView = [UIView new];
    _endView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.contentView addSubview:_endView];
    [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLabel.mas_bottom).offset(10);
        make.left.equalTo(@12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
