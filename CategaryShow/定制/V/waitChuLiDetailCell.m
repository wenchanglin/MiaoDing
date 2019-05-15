//
//  waitChuLiDetailCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/17.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "waitChuLiDetailCell.h"

@implementation waitChuLiDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _yhqLabel = [UILabel new];
    _yhqLabel.font=[UIFont fontWithName:@"PingFangSC-Light" size:14];
    _yhqLabel.textColor =[UIColor colorWithHexString:@"#666666"];
    [self addSubview:_yhqLabel];
    _otherLabel = [UILabel new];
    _otherLabel.font=[UIFont fontWithName:@"PingFangSC-Light" size:14];
    _otherLabel.textColor =[UIColor colorWithHexString:@"#666666"];
    [self addSubview:_otherLabel];
    _zekouLabel = [UILabel new];
    _zekouLabel.font=[UIFont fontWithName:@"PingFangSC-Light" size:14];
    _zekouLabel.textColor =[UIColor colorWithHexString:@"#666666"];
    [self addSubview:_zekouLabel];
    _shiJiLabel = [UILabel new];
    _shiJiLabel.font=[UIFont fontWithName:@"PingFangSC-Light" size:14];
    _shiJiLabel.textColor =[UIColor colorWithHexString:@"#666666"];
    [self addSubview:_shiJiLabel];
    _priceLabel = [UILabel new];
    _priceLabel.textColor =[UIColor colorWithHexString:@"#222222"];
    _priceLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    [self addSubview:_priceLabel];
    _endView= [UIView new];
    _endView.backgroundColor =[UIColor colorWithHexString:@"#E8E8E8"];
    [self addSubview:_endView];
}
-(void)layoutSubviews
{
    [_yhqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14.5);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    [_otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yhqLabel.mas_bottom).offset(1);
        make.left.width.height.equalTo(_yhqLabel);
    }];
    [_zekouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_otherLabel.mas_bottom).offset(1);
        make.left.width.height.equalTo(_otherLabel);
    }];
    [_shiJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zekouLabel.mas_bottom).offset(1);
        make.left.width.height.equalTo(_zekouLabel);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_yhqLabel.mas_centerY);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(25);
    }];
    [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(20.6);
        make.top.equalTo(_shiJiLabel.mas_bottom).offset(18);
        make.height.mas_equalTo(1);
    }];
}
-(void)setModel:(waitChuLiModel *)model
{
    _model=model;
    _yhqLabel.text = [NSString stringWithFormat:@"优惠券减:%@",model.ticket_reduce_money];
    _otherLabel.text = [NSString stringWithFormat:@"其他扣减:%.2f",[model.order_amount floatValue]-[model.payable_amount floatValue]-[model.ticket_reduce_money floatValue]];
    _zekouLabel.text = [NSString stringWithFormat:@"折扣系数:%@",model.discount];
    _shiJiLabel.text = [NSString stringWithFormat:@"实需付款:%@",model.payable_amount];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.order_amount];
}
@end
