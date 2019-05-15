//
//  NewMainTabListTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "NewMainTabListTableViewCell.h"


@implementation NewMainTabListTableViewCell
{
    UIView *firstView;
    UILabel *numberWatch;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    _mainImg = [UIImageView new];
    _mainImg.contentMode = UIViewContentModeScaleAspectFill;
    [_mainImg.layer setMasksToBounds:YES];
    [self.contentView addSubview:_mainImg];
    [_mainImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(434);
    }];
    _headLabel = [UILabel new];
    _headLabel.font = [UIFont fontWithName:@"PingFangTC-Regular" size:22];
    _headLabel.textColor = [UIColor colorWithHexString:@"#202020"];
    [self.contentView addSubview:_headLabel];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainImg.mas_bottom).offset(24);
        make.centerX.equalTo(_mainImg.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont fontWithName:@"PingFangTC-Regular" size:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#202020"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mainImg.mas_centerX);
        make.top.equalTo(_headLabel.mas_bottom).offset(1);
        make.height.equalTo(@20);
    }];
    
    //    firstView = [UIView new];
    //    firstView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    //    [self.contentView addSubview:firstView];
    //    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_nameLabel.mas_bottom).offset(10.3);
    //        make.left.right.equalTo(_mainImg);
    //        make.height.mas_equalTo(2);
    //    }];
    //    _zhuanFaBtn = [UIButton new];
    //    _zhuanFaBtn.tag = 21;
    //    [_zhuanFaBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [_zhuanFaBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
    //    [self.contentView addSubview:_zhuanFaBtn];
    //    [_zhuanFaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(firstView.mas_bottom).offset(10);
    //        make.left.mas_equalTo(12);
    //        make.height.and.width.mas_equalTo(20);
    //    }];
    //    _shouCangBtn = [UIButton new];
    //    [_shouCangBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [_shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    //
    //    _shouCangBtn.tag = 22;
    //    [self.contentView addSubview:_shouCangBtn];
    //    [_shouCangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(_zhuanFaBtn.mas_centerY);
    //        make.left.equalTo(_zhuanFaBtn.mas_right).offset(20);
    //        make.width.mas_equalTo(20);
    //        make.height.mas_equalTo(18);
    //    }];
    //    _xiHuanBtn = [UIButton new];
    //    [_xiHuanBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    _xiHuanBtn.tag=23;
    ////    [_xiHuanBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    //    _xiHuanBtn.titleLabel.font =[UIFont systemFontOfSize:10];//[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:6];
    //   // [_xiHuanBtn setTitle:@"20000" forState:UIControlStateNormal];
    //    _xiHuanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    _xiHuanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    //    [_xiHuanBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    //    [self.contentView addSubview:_xiHuanBtn];
    //    [_xiHuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(_shouCangBtn.mas_centerY);
    //        make.left.equalTo(_shouCangBtn.mas_right).offset(20);
    //        make.width.mas_equalTo(80);
    //        make.height.mas_equalTo(16);
    //    }];
    //    _pingLunBtn = [UIButton new];
    //    [_pingLunBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    _pingLunBtn.tag = 24;
    //    _pingLunBtn.titleLabel.font =[UIFont systemFontOfSize:10];
    //    _pingLunBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [_pingLunBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    //    _pingLunBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    //    [_pingLunBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    //    [self.contentView addSubview:_pingLunBtn];
    //    [_pingLunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(_zhuanFaBtn.mas_centerY);
    //        make.left.equalTo(_xiHuanBtn.mas_right).offset(-20);
    //        make.width.mas_equalTo(80);
    //        make.height.mas_equalTo(20);
    //    }];
    //    _lastView = [UIView new];
    //    _lastView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    //    [self.contentView addSubview:_lastView];
    //    [_lastView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_zhuanFaBtn.mas_bottom).offset(10);
    //        make.left.right.equalTo(self.contentView);
    //        make.height.mas_equalTo(12);
    //    }];
}
-(void)fourBtn:(UIButton *)button
{
    _FourBtn(button);
    
}
-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    
    
}
-(void)setModel:(NewMainModel *)model
{
    _model = model;
    [_mainImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.img]]placeholderImage:[UIImage imageNamed:@"loading"]];
    CGFloat realHeight;
    if ([model.img_info isEqualToString:@""]||model.img_info==nil) {
        realHeight = 0.0001;
    }
    else
    {
        realHeight= (SCREEN_WIDTH-24) /[model.img_info floatValue];
    }
    [_mainImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(realHeight);
    }];
    _headLabel.text=model.title;
    [_nameLabel setText:model.sub_title];
  
}


@end
