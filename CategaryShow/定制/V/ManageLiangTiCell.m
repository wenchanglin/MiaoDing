//
//  ManageLiangTiCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/24.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "ManageLiangTiCell.h"

@implementation ManageLiangTiCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    return self;
}
-(void)setUp
{
    UILabel *nameTitle = [UILabel new];
    nameTitle.font =[UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    nameTitle.textColor = [UIColor colorWithHexString:@"#222222"];
    [nameTitle setText:@"姓名："];
    [self.contentView addSubview:nameTitle];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#6F6F6F"];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTitle);
        make.left.equalTo(nameTitle.mas_right).offset(5);
    }];
    UILabel *heightTitle = [UILabel new];
    heightTitle.font =[UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    heightTitle.textColor = [UIColor colorWithHexString:@"#222222"];
    [heightTitle setText:@"身高："];
    [self.contentView addSubview:heightTitle];
    [heightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(nameTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    _heightLabel = [UILabel new];
    _heightLabel.textColor = [UIColor colorWithHexString:@"#6F6F6F"];
    _heightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.contentView addSubview:_heightLabel];
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(heightTitle);
        make.left.equalTo(heightTitle.mas_right).offset(5);
    }];
    UILabel *weightTitle = [UILabel new];
    weightTitle.font =[UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    weightTitle.textColor = [UIColor colorWithHexString:@"#222222"];
    [weightTitle setText:@"体重："];
    [self.contentView addSubview:weightTitle];
    [weightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_heightLabel.mas_right).offset(22);
        make.top.equalTo(heightTitle);
        make.height.mas_equalTo(20);
    }];
    _weightLabel = [UILabel new];
    _weightLabel.textColor = [UIColor colorWithHexString:@"#6F6F6F"];
    _weightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self.contentView addSubview:_weightLabel];
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weightTitle);
        make.left.equalTo(weightTitle.mas_right).offset(5);
    }];
    UIView * fengeView = [UIView new];
    fengeView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.contentView addSubview:fengeView];
    [fengeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_heightLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    _mainImageViews =[UIImageView new];
    _mainImageViews.userInteractionEnabled = YES;
    [self.contentView addSubview:_mainImageViews];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_mainImageViews addGestureRecognizer:tap];
    [_mainImageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fengeView.mas_bottom).offset(1);
        make.left.mas_equalTo(2);
        make.width.mas_equalTo(SCREEN_WIDTH/2-30);
        make.height.equalTo(@30);
    }];
    _chooseBtn = [UIButton new];
    _chooseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [_chooseBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    [_mainImageViews addSubview:_chooseBtn];

}
-(void)tap:(UITapGestureRecognizer *)tap
{
//    WCLLog(@"你点击了我");
}
-(void)setModels:(LiangTiModel *)models
{
    _models = models;
    _nameLabel.text = models.name;
    _heightLabel.text = [NSString stringWithFormat:@"%@cm",@(models.height)];
    _weightLabel.text = [NSString stringWithFormat:@"%@kg",@(models.weight)];
    if (models.is_default ==1) {
        [_chooseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_weightLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(2);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(20);
        }];
        [_chooseBtn setImage:[UIImage imageNamed:@"addressChoose"] forState:UIControlStateNormal];
        [_chooseBtn setTitle:@"设为默认量体数据" forState:(UIControlStateNormal)];
    } else {
        [_chooseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_weightLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(2);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(20);

        }];
        [_chooseBtn setImage:[UIImage imageNamed:@"addressNoChoose"] forState:UIControlStateNormal];
        [_chooseBtn setTitle:@"设为默认量体数据" forState:(UIControlStateNormal)];
        [_chooseBtn addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)chooseAction
{
    if ([_delegate respondsToSelector:@selector(clickChooseLiangTi:)]) {
        [_delegate clickChooseLiangTi:self.tag - 10];
    }
}
-(void)updateAction
{
    if ([_delegate respondsToSelector:@selector(clickUpdateLiangTi:)]) {
        [_delegate clickUpdateLiangTi:self.tag - 10];
    }
}
@end
