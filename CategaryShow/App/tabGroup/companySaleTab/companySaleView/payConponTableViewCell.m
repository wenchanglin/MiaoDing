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
        _yhquanImageView = [UIImageView new];
        [self addSubview:_yhquanImageView];
        [_yhquanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(17);
        }];
        _chooseCon = [[UILabel alloc] init];
        _chooseCon.textColor = [UIColor colorWithHexString:@"#222222"];
        _chooseCon.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [self.contentView addSubview:_chooseCon];
        [_chooseCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yhquanImageView.mas_right).offset(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        _tikerNumLabel = [[UILabel alloc] init];
        _tikerNumLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _tikerNumLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [self.contentView addSubview:_tikerNumLabel];
        [_tikerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(_chooseCon.mas_centerY);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
