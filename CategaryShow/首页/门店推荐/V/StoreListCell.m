//
//  StoreListCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/13.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoreListCell.h"

@implementation StoreListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _mainImageView = [UIImageView new];
//    _mainImageView.backgroundColor = [UIColor cyanColor];
    _mainImageView.layer.shadowOffset = CGSizeMake(0, -3);
    _mainImageView.layer.shadowRadius =3;
    _mainImageView.layer.shadowOpacity = 0.5;
    _mainImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:_mainImageView];
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.width.height.mas_equalTo(69);
    }];
    _nameLabel = [UILabel new];
    _nameLabel.numberOfLines =0;
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainImageView);
        make.left.equalTo(_mainImageView.mas_right).offset(16);
        make.height.mas_equalTo(22);
    }];
    _fansLabel = [UILabel new];
    _fansLabel.numberOfLines = 0;
    _fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _fansLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_fansLabel];
    [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(4);
        make.left.equalTo(_nameLabel);
        make.height.mas_equalTo(17);
    }];
    _addressLabel = [UILabel new];
    _addressLabel.numberOfLines =0;
    _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    _addressLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fansLabel.mas_bottom).offset(6);
        make.left.equalTo(_nameLabel);
        make.height.mas_equalTo(17);
    }];
    
}
-(void)setModel:(StoreListModel *)model
{
    _model =model;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL,model.img]]];
    _nameLabel.text = model.name;
    _fansLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:model.lovenum]];
    _addressLabel.text = model.address;

}
@end
