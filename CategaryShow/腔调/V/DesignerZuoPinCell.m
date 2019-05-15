//
//  DesignerZuoPinCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/10.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "DesignerZuoPinCell.h"

@implementation DesignerZuoPinCell
{
    UIImageView * clothesImg;
    UILabel * zuoPinName;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}
-(void)setUp
{
    UIView *contentView = self.contentView;
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    [clothesImg.layer setMasksToBounds:YES];
    [clothesImg.layer setCornerRadius:3];
    clothesImg.contentMode = UIViewContentModeScaleAspectFill;
    [clothesImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@15);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(217.7);
    }];
    zuoPinName = [UILabel new];
    zuoPinName.text = @"秋季外套";
    zuoPinName.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    zuoPinName.textColor = [UIColor colorWithHexString:@"#222222"];
    [contentView addSubview:zuoPinName];
    [zuoPinName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clothesImg);
        make.top.equalTo(clothesImg.mas_bottom).offset(11.3);
        make.height.mas_equalTo(20);
    }];
    UIView * view1 = [UIView new];
    view1.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [contentView addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(clothesImg);
        make.top.equalTo(zuoPinName.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    _zhuanFaBtn = [UIButton new];
    _zhuanFaBtn.tag = 41;
    [_zhuanFaBtn addTarget:self action:@selector(zuoPinFourBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_zhuanFaBtn setImage:[UIImage imageNamed:@"转发"] forState:(UIControlStateNormal)];
    [contentView addSubview:_zhuanFaBtn];
    [_zhuanFaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom).offset(10);
        make.left.equalTo(clothesImg);
        make.width.height.mas_equalTo(20);
    }];
    _shouChangBtn = [UIButton new];
    _shouChangBtn.tag = 42;
    [_shouChangBtn addTarget:self action:@selector(zuoPinFourBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
    [contentView addSubview:_shouChangBtn];
    [_shouChangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhuanFaBtn.mas_centerY);
        make.left.equalTo(_zhuanFaBtn.mas_right).offset(25);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    _loveBtn = [UIButton new];
    [_loveBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    _loveBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_loveBtn addTarget:self action:@selector(zuoPinFourBtn:) forControlEvents:UIControlEventTouchUpInside];
    _loveBtn.tag =43;
    _loveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _loveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:(UIControlStateNormal)];
    [contentView addSubview:_loveBtn];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhuanFaBtn.mas_centerY);
        make.left.equalTo(_shouChangBtn.mas_right).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(16);
    }];
    //    _commentBtn = [UIButton new];
    //    _commentBtn.tag =44;
    //    [_commentBtn addTarget:self action:@selector(fourBtns:) forControlEvents:UIControlEventTouchUpInside];
    //    [_commentBtn setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
    //    [contentView addSubview:_commentBtn];
    //    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(_zhuanFaBtn);
    //        make.left.equalTo(_loveBtn.mas_right).offset(24);
    //        make.width.height.mas_equalTo(20);
    //    }];
    UIView * fengeView = [UIView new];
    [contentView addSubview:fengeView];
    fengeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanFaBtn.mas_bottom).offset(16);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(12);
    }];
}
-(void)setModels:(DesignerGoodsListModel *)models
{
    _models = models;
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL,models.thumb]]];
    CGFloat realHeight;
    if ([models.img_info isEqualToString:@""]||models.img_info==nil) {
        realHeight = 0.0001;
    }
    else
    {
    realHeight= (SCREEN_WIDTH-24) /[models.img_info floatValue];
    }
    [clothesImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@15);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(realHeight);
    }];
    zuoPinName.text = models.name;
    if(models.is_love ==0)
    {
        [_loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    }
    else if(models.is_love  == 1)
    {
        [_loveBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
    }
    
    if(models.is_collect  ==0)
    {
        [_shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        
    }
    else if(models.is_collect ==1)
    {
        [_shouChangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
        
    }
    [_loveBtn setTitle:[NSString stringWithFormat:@"%zd",models.love_num] forState:UIControlStateNormal];
}
-(void)zuoPinFourBtn:(UIButton*)button
{
    _ZuoPinFourBtns(button);
}
@end
