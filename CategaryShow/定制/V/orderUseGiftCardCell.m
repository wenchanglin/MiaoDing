//
//  orderUseGiftCardCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/17.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "orderUseGiftCardCell.h"

@implementation orderUseGiftCardCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.userInteractionEnabled=YES;
    _firstLabel = [UILabel new];
    _firstLabel.font=[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _firstLabel.textColor =[UIColor colorWithHexString:@"#222222"];
    _firstLabel.text=@"使用礼品卡余额抵扣";
    [self addSubview:_firstLabel];
    _switchView = [UIButton new];
    [_switchView setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [_switchView addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_switchView];
    _giftCardLabel = [UILabel new];
    _giftCardLabel.font=[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    _giftCardLabel.textColor =[UIColor colorWithHexString:@"#666666"];
    [self addSubview:_giftCardLabel];
    _heJiLabel = [UILabel new];
    _heJiLabel.font=[UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    _heJiLabel.textColor =[UIColor colorWithHexString:@"#222222"];
    [self addSubview:_heJiLabel];
    _toPayBtn = [UIButton new];
    [_toPayBtn setTitle:@"去付款" forState:UIControlStateNormal];
    _toPayBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [_toPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _toPayBtn.backgroundColor = [UIColor blackColor];
    _toPayBtn.layer.cornerRadius=4;
    _toPayBtn.tag=200;
    _toPayBtn.layer.borderColor=[UIColor colorWithHexString:@"#9FA0A3"].CGColor;
    _toPayBtn.layer.borderWidth=1;
    [_toPayBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_toPayBtn];
    _exchageBtn = [UIButton new];
    [_exchageBtn setTitle:@"兑换礼品卡" forState:UIControlStateNormal];
    _exchageBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [_exchageBtn setTitleColor:[UIColor colorWithHexString:@"#202020"] forState:UIControlStateNormal];
    _exchageBtn.backgroundColor = [UIColor whiteColor];
    _exchageBtn.layer.cornerRadius=4;
    _exchageBtn.tag=199;
    _exchageBtn.layer.borderColor=[UIColor colorWithHexString:@"#9FA0A3"].CGColor;
    _exchageBtn.layer.borderWidth=1;
    [_exchageBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exchageBtn];
}
-(void)layoutSubviews
{
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(17);
        make.centerY.equalTo(_firstLabel.mas_centerY);
    }];
    [_giftCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstLabel);
        make.top.equalTo(_firstLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(22);
    }];
    [_heJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstLabel);
        make.top.equalTo(_giftCardLabel.mas_bottom).offset(62);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
    }];
    [_toPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(_heJiLabel.mas_centerY);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(84);
    }];
    [_exchageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_toPayBtn.mas_left).offset(-20);
        make.centerY.equalTo(_toPayBtn.mas_centerY);
        make.width.height.equalTo(_toPayBtn);
    }];
}
-(void)twoBtnClick:(UIButton*)btn
{
    switch (btn.tag) {
        case 199://兑换礼品卡
            {
                if ([self.delegate respondsToSelector:@selector(exChangeGiftCardwithCell:)]) {
                    [self.delegate exChangeGiftCardwithCell:self];
                }
            }
            break;
        case 200://去付款
        {
            if ([self.delegate respondsToSelector:@selector(goToPaywithCell:)]) {
                [self.delegate goToPaywithCell:self];
            }
        }break;
        default:
            break;
    }
}
-(void) switchValueChanged:(UIButton*)sender{
    sender.selected=!sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.2 animations:^{
        [_switchView setImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        }];
        self.useGiftCardBlock(YES);
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [_switchView setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        }];
        self.useGiftCardBlock(NO);
    }
}

@end
