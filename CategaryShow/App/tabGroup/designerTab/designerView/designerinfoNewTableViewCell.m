//
//  designerinfoNewTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerinfoNewTableViewCell.h"

@implementation designerinfoNewTableViewCell

{
    UILabel * zuoPinLabel;
    UIImageView *designerHead;
    UIImageView *clothesImg;
    UILabel * designerCard;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}


-(void)setUp
{
    UIView *contentView = self.contentView;
    zuoPinLabel = [UILabel new];
    zuoPinLabel.font = [UIFont boldSystemFontOfSize:14];
    zuoPinLabel.textColor = [UIColor colorWithHexString:@"#202020"];
    [contentView addSubview:zuoPinLabel];
    [zuoPinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(18);
    }];
    clothesImg = [UIImageView new];
    [contentView addSubview:clothesImg];
    [clothesImg.layer setMasksToBounds:YES];
    [clothesImg.layer setCornerRadius:3];
    clothesImg.contentMode = UIViewContentModeScaleAspectFill;
    [clothesImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zuoPinLabel);
        make.top.equalTo(zuoPinLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(217.7);
    }];
    designerCard = [UILabel new];
    designerCard.font = [UIFont systemFontOfSize:14];
    designerCard.textColor = [UIColor colorWithHexString:@"#202020"];
    [contentView addSubview:designerCard];
    [designerCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(clothesImg);
        make.top.equalTo(clothesImg.mas_bottom).offset(10);
    }];
    _desinerView = [UIView new];
    _desinerView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [contentView addSubview:_desinerView];
    [_desinerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(designerCard.mas_bottom).offset(10);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(1);
    }];
   
    _loveBtn = [UIButton new];
    [_loveBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    _loveBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_loveBtn addTarget:self action:@selector(fourBtns:) forControlEvents:UIControlEventTouchUpInside];
    _loveBtn.tag =33;
    _loveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _loveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:(UIControlStateNormal)];
    [contentView addSubview:_loveBtn];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_desinerView.mas_bottom).offset(10);
        make.right.mas_equalTo(-1);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
    }];
    _shouChangBtn = [UIButton new];
    _shouChangBtn.tag = 32;
    [_shouChangBtn addTarget:self action:@selector(fourBtns:) forControlEvents:UIControlEventTouchUpInside];
    [_shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
    [contentView addSubview:_shouChangBtn];
    [_shouChangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_loveBtn.mas_centerY);
        make.right.equalTo(_loveBtn.mas_left).offset(-25);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
    }];
    
    _zhuanFaBtn = [UIButton new];
    _zhuanFaBtn.tag = 31;
    [_zhuanFaBtn addTarget:self action:@selector(fourBtns:) forControlEvents:UIControlEventTouchUpInside];
    [_zhuanFaBtn setImage:[UIImage imageNamed:@"转发"] forState:(UIControlStateNormal)];
    [contentView addSubview:_zhuanFaBtn];
    [_zhuanFaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_loveBtn.mas_centerY);
        make.right.equalTo(_shouChangBtn.mas_left).offset(-25);
        make.width.height.mas_equalTo(20);
    }];
    UIView * fengeView = [UIView new];
    [contentView addSubview:fengeView];
    fengeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanFaBtn.mas_bottom).offset(10);
        make.left.right.equalTo(contentView);
        make.height.mas_equalTo(12);
    }];
    
}
-(void)fourBtns:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(moreBtnClickWithBtnTag:withModel:withCell:)]) {
        [self.delegate moreBtnClickWithBtnTag:button.tag withModel:_model withCell:self];
    }
}

-(void)setModel:(designerModel *)model
{
    _model = model;
    if(model.is_love ==0)
    {
        [_loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    }
    else if(model.is_love  == 1)
    {
        [_loveBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
    }
    
    if(model.is_collect  ==0)
    {
        [_shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        
    }
    else if(model.is_collect ==1)
    {
        [_shouChangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
        
    }
    [_loveBtn setTitle:[NSString stringWithFormat:@"%zd",model.love_num] forState:UIControlStateNormal];
    zuoPinLabel.text = model.name;
    designerCard.text =model.content;
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.ad_img]]];
    CGFloat realHeight;
    if ([model.ad_img_info isEqualToString:@""]||model.ad_img_info==nil) {
        realHeight = 0.0001;
    }
    else
    {
        realHeight = (SCREEN_WIDTH-24) /[model.ad_img_info floatValue];
    }
    [clothesImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zuoPinLabel);
        make.top.equalTo(zuoPinLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(realHeight);
    }];
  
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
