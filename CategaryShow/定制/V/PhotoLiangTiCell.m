//
//  PhotoLiangTiCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/24.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "PhotoLiangTiCell.h"

@implementation PhotoLiangTiCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _liangTiLabel = [UILabel new];
    _liangTiLabel.text = @"量体数据确认";
    _liangTiLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    _liangTiLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_liangTiLabel];
    [_liangTiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(_liangTiLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    _heightLabel = [UILabel new];
    _heightLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _heightLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_heightLabel];
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(20);
    }];
    _weightLabel = [UILabel new];
    _weightLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    _weightLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_weightLabel];
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_heightLabel.mas_right).offset(22);
        make.top.equalTo(_heightLabel);
        make.height.mas_equalTo(20);
    }];
}
-(void)setModels:(LiangTiModel *)models
{
    _models = models;
    if(models.name.length>0)
    {
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",models.name];
    }else
    {
        _nameLabel.text = [NSString stringWithFormat:@"姓名："];
    }
    _heightLabel.text = [NSString stringWithFormat:@"身高：%@cm",@(models.height)];
    _weightLabel.text = [NSString stringWithFormat:@"体重：%@kg",@(models.weight)];
}
@end
