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
    UIImageView *mainImg;
    UILabel *nameLabel;
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
    mainImg = [UIImageView new];
    [self.contentView addSubview:mainImg];
    [mainImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(217.7);
    }];
    
    nameLabel = [UILabel new];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    nameLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(mainImg);
        make.top.equalTo(mainImg.mas_bottom).offset(11);
        make.height.equalTo(@20);
    }];
    
    firstView = [UIView new];
    firstView.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [self.contentView addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(10.3);
        make.left.right.equalTo(mainImg);
        make.height.mas_equalTo(2);
    }];
    _zhuanFaBtn = [UIButton new];
    [_zhuanFaBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
    [self.contentView addSubview:_zhuanFaBtn];
    [_zhuanFaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.height.and.width.mas_equalTo(20);
    }];
    _shouCangBtn = [UIButton new];
    [_shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [self.contentView addSubview:_shouCangBtn];
    [_shouCangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(10);
        make.left.equalTo(_zhuanFaBtn.mas_right).offset(20);
        make.height.and.width.mas_equalTo(20);
    }];
    _xiHuanBtn = [UIButton new];
    [_xiHuanBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    _xiHuanBtn.titleLabel.font =[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:6];
    [_xiHuanBtn setTitle:@"20000" forState:UIControlStateNormal];
    _xiHuanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _xiHuanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_xiHuanBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [self.contentView addSubview:_xiHuanBtn];
    [_xiHuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(10);
        make.left.equalTo(_shouCangBtn.mas_right).offset(20);
        make.width.mas_equalTo(80);
    }];
    _pingLunBtn = [UIButton new];
    _pingLunBtn.titleLabel.font =[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:10];
    _pingLunBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_pingLunBtn setTitle:@"10000" forState:UIControlStateNormal];
    [_pingLunBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    _pingLunBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_pingLunBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [self.contentView addSubview:_pingLunBtn];
    [_pingLunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(10);
        make.left.equalTo(_xiHuanBtn.mas_right).offset(20);
        make.width.mas_equalTo(80);
    }];
    _lastView = [UIView new];
    _lastView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.contentView addSubview:_lastView];
    [_lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhuanFaBtn.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(12);
    }];
}

-(void)setModel:(NewMainModel *)model
{
    _model = model;
    [mainImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.ImageUrl]]];
    mainImg.contentMode = UIViewContentModeScaleAspectFill;
    [mainImg.layer setMasksToBounds:YES];
    
    
    
    [nameLabel setText:model.name];
   // [nameContent setText:model.titleContent];
    //[numberWatch setText:model.detail];
    
}


@end
