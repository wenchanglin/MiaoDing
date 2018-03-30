//
//  StoreSaveCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoreSaveCell.h"

@implementation StoreSaveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _tupianImageView = [UIImageView new];
    _tupianImageView.layer.borderWidth = 1;
    _tupianImageView.layer.masksToBounds = YES;
    _tupianImageView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:_tupianImageView];
    [_tupianImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.width.height.mas_equalTo(69);
    }];
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tupianImageView);
        make.left.equalTo(_tupianImageView.mas_right).offset(16);
        make.height.mas_equalTo(22);
    }];
    _fansLabel = [UILabel new];
    _fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _fansLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_fansLabel];
    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(4);
        make.left.equalTo(_tupianImageView.mas_right).offset(16);
        make.height.mas_equalTo(17);
    }];
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    _addressLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fansLabel.mas_bottom).offset(6);
        make.left.equalTo(_tupianImageView.mas_right).offset(16);
        make.height.mas_equalTo(17);
    }];
}
-(void)setModel:(StoreSaveModel *)model
{
    _model =model;
    _nameLabel.text = model.factory_name;
    _fansLabel.text = [NSString stringWithFormat:@"%ld",model.lovenum];
    _addressLabel.text = [NSString stringWithFormat:@"地址:%@",model.address];
}
@end
