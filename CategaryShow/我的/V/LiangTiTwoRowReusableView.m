//
//  LiangTiTwoRowReusableView.m
//  CategaryShow
//
//  Created by 文长林 on 2019/5/5.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "LiangTiTwoRowReusableView.h"

@implementation LiangTiTwoRowReusableView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self.titleLabels mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-35);
        }];
        [self.zuoHuaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabels.mas_bottom).offset(20);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(60);
        }];
        [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.zuoHuaImageView.mas_centerY);
            make.right.equalTo(self.zuoHuaImageView.mas_left).offset(-41);
            make.width.height.mas_equalTo(67);
        }];
        [self.twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.zuoHuaImageView.mas_centerY);
            make.left.equalTo(self.zuoHuaImageView.mas_right).offset(41);
            make.width.height.mas_equalTo(67);
        }];
        [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabels);
            make.top.equalTo(self.firstBtn.mas_bottom).offset(40);
            make.right.mas_equalTo(-30);
        }];
    }
    return self;
}
-(UILabel *)titleLabels
{
    if (!_titleLabels) {
        _titleLabels = [UILabel new];
        _titleLabels.numberOfLines=1;
        _titleLabels.font=[UIFont systemFontOfSize:11];
        _titleLabels.text =@"根据您的量体数据，如购买成衣，推荐尺码为：";
        _titleLabels.textColor = [UIColor colorWithHexString:@"#7E818C"];
        [self addSubview:_titleLabels];
    }
    return _titleLabels;
}
-(UIImageView *)zuoHuaImageView
{
    if (!_zuoHuaImageView) {
        _zuoHuaImageView = [UIImageView new];
        _zuoHuaImageView.image=[UIImage imageNamed:@"fengelt"];
        _zuoHuaImageView.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:_zuoHuaImageView];
    }
    return _zuoHuaImageView;
}
-(UIButton *)firstBtn
{
    if (!_firstBtn) {
        _firstBtn=[UIButton new];
        _firstBtn.layer.cornerRadius=33.5;
        [_firstBtn setTitle:@"180" forState:UIControlStateNormal];
        [_firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _firstBtn.backgroundColor =[UIColor colorWithHexString:@"#D9C38A"];
        _firstBtn.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        _firstBtn.layer.masksToBounds=YES;
        [self addSubview:_firstBtn];
    }
    return _firstBtn;
}
-(UIButton *)twoBtn
{
    if (!_twoBtn) {
        _twoBtn=[UIButton new];
        _twoBtn.layer.cornerRadius=33.5;
        [_twoBtn setTitle:@"84A" forState:UIControlStateNormal];
        [_twoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _twoBtn.backgroundColor =[UIColor colorWithHexString:@"#D9C38A"];
        _twoBtn.titleLabel.font=[UIFont boldSystemFontOfSize:18];
        _twoBtn.layer.masksToBounds=YES;
        [self addSubview:_twoBtn];
    }
    return _twoBtn;
}
-(UILabel *)endLabel
{
    if (!_endLabel) {
        _endLabel = [UILabel new];
        _endLabel.numberOfLines=1;
        _endLabel.font=[UIFont systemFontOfSize:11];
        _endLabel.text =@"*尺码建议仅供参考，追求完美合身效果，请选择妙定量身定制";
        _endLabel.textColor = [UIColor colorWithHexString:@"#7E818C"];
        [self addSubview:_endLabel];
    }
    return _endLabel;
}
@end
