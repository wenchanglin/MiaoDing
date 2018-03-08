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
    UILabel * zuoPinMoreLabel;
    UIImageView *designerHead;
    UILabel *designerName;
    UILabel *designerMore;
    UILabel *designerJieShao;
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
    zuoPinLabel.text = @"设计师作品";
    zuoPinLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    zuoPinLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [contentView addSubview:zuoPinLabel];
    [zuoPinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(18);
    }];
    zuoPinMoreLabel = [UILabel new];
    zuoPinMoreLabel.text = @"more >";
    zuoPinMoreLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    zuoPinMoreLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [contentView addSubview:zuoPinMoreLabel];
    [zuoPinMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zuoPinLabel.mas_centerY);
        make.right.mas_equalTo(-12);
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
    _desinerView = [UIView new];
  //  _desinerView.backgroundColor = [UIColor magentaColor];
    _desinerView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_desinerView addGestureRecognizer:tap];
    [contentView addSubview:_desinerView];
    [_desinerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(clothesImg.mas_bottom);
        make.left.right.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-12);
    }];
    designerName = [UILabel new];
    designerName.text = @"设计师简介";
    designerName.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    designerName.textColor = [UIColor colorWithHexString:@"#222222"];
    [contentView addSubview:designerName];
    [designerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zuoPinLabel);
        make.top.equalTo(clothesImg.mas_bottom).offset(10.3);
        make.height.mas_equalTo(18);
    }];

    designerMore = [UILabel new];
    designerMore.text = @"更多 >";
    designerMore.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    designerMore.textColor = [UIColor colorWithHexString:@"#222222"];
    [contentView addSubview:designerMore];
    [designerMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(designerName.mas_centerY);
        make.right.mas_equalTo(-12);
    }];

    designerHead = [UIImageView new];
    [contentView addSubview:designerHead];
    designerHead.backgroundColor = [UIColor cyanColor];
    [designerHead.layer setMasksToBounds:YES];
    [designerHead.layer setCornerRadius:3];
    designerHead.contentMode = UIViewContentModeScaleAspectFill;
    [designerHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(designerName.mas_bottom).offset(10);
        make.width.height.mas_equalTo(69);
    }];

    designerJieShao = [UILabel new];
    designerJieShao.numberOfLines =0;
    designerJieShao.text = @"国内顶级服饰设计师作品发布平台每一件独具匠心的作品都值得被世人传颂在这里。";
    designerJieShao.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    designerJieShao.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    [contentView addSubview:designerJieShao];
    [designerJieShao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(designerHead.mas_right).offset(15);
        make.top.equalTo(designerName.mas_bottom).offset(10);
        make.right.mas_equalTo(-12);
    }];
    designerCard = [UILabel new];
    designerCard.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    designerCard.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    [contentView addSubview:designerCard];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:@"陈振富/方言设计工作室"];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15]
                    range:NSMakeRange(0, 3)];
    designerCard.attributedText = attrStr;
    [designerCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(designerJieShao.mas_bottom).offset(9);
        make.left.equalTo(designerJieShao);
    }];
    _zhuanFaBtn = [UIButton new];
    [_zhuanFaBtn setImage:[UIImage imageNamed:@"转发"] forState:(UIControlStateNormal)];
    [contentView addSubview:_zhuanFaBtn];
    [_zhuanFaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(designerHead.mas_bottom).offset(23);
        make.left.equalTo(designerHead);
        make.width.height.mas_equalTo(20);
    }];
    _shouChangBtn = [UIButton new];
    [_shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
    [contentView addSubview:_shouChangBtn];
    [_shouChangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanFaBtn);
        make.left.equalTo(_zhuanFaBtn.mas_right).offset(24);
        make.width.height.mas_equalTo(20);
    }];
    _loveBtn = [UIButton new];
    [_loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:(UIControlStateNormal)];
    [contentView addSubview:_loveBtn];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanFaBtn);
        make.left.equalTo(_shouChangBtn.mas_right).offset(24);
        make.width.height.mas_equalTo(20);
    }];
    _commentBtn = [UIButton new];
    [_commentBtn setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
    [contentView addSubview:_commentBtn];
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanFaBtn);
        make.left.equalTo(_loveBtn.mas_right).offset(24);
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
-(void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"你点击了我");
}
-(void)setModel:(designerModel *)model
{
    
    _model = model;
//    [designerHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.designerHead]]];
   // [designerName setText:model.designerName];
//    [time setText:model.p_time];
   // [clothesName setText:model.titlename];
    [clothesImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.clothesImage]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
