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
    mainImg.contentMode = UIViewContentModeScaleAspectFill;
    [mainImg.layer setMasksToBounds:YES];
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
    _zhuanFaBtn.tag = 21;
    [_zhuanFaBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_zhuanFaBtn setImage:[UIImage imageNamed:@"转发"] forState:UIControlStateNormal];
    [self.contentView addSubview:_zhuanFaBtn];
    [_zhuanFaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.height.and.width.mas_equalTo(20);
    }];
    _shouCangBtn = [UIButton new];
    [_shouCangBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];

    _shouCangBtn.tag = 22;
    [self.contentView addSubview:_shouCangBtn];
    [_shouCangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhuanFaBtn.mas_centerY);
        make.left.equalTo(_zhuanFaBtn.mas_right).offset(20);
        make.height.and.width.mas_equalTo(20);
    }];
    _xiHuanBtn = [UIButton new];
    [_xiHuanBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    _xiHuanBtn.tag=23;
//    [_xiHuanBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    _xiHuanBtn.titleLabel.font =[UIFont systemFontOfSize:10];//[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:6];
   // [_xiHuanBtn setTitle:@"20000" forState:UIControlStateNormal];
    _xiHuanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _xiHuanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_xiHuanBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [self.contentView addSubview:_xiHuanBtn];
    [_xiHuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shouCangBtn.mas_centerY);
        make.left.equalTo(_shouCangBtn.mas_right).offset(20);
        make.width.mas_equalTo(80);
    }];
    _pingLunBtn = [UIButton new];
    [_pingLunBtn addTarget:self action:@selector(fourBtn:) forControlEvents:UIControlEventTouchUpInside];
    _pingLunBtn.tag = 24;
    _pingLunBtn.titleLabel.font =[UIFont systemFontOfSize:10];
    _pingLunBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_pingLunBtn setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    _pingLunBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_pingLunBtn setTitleColor:[UIColor colorWithHexString:@"#A6A6A6"] forState:UIControlStateNormal];
    [self.contentView addSubview:_pingLunBtn];
    [_pingLunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhuanFaBtn.mas_centerY);
        make.left.equalTo(_xiHuanBtn.mas_right).offset(-20);
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
-(void)fourBtn:(UIButton *)button
{
    _FourBtn(button);
//    switch (button.tag) {
//        case 21:
//        {
//            [self shareClick];
//        }
//            break;
//         case 22:
//        {
//            if(button.selected)
//            {
//                [_shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
//
//                button.selected = NO;
//            }
//            else
//            {
//                [_shouCangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
//                button.selected = YES;
//            }
//        }break;
//            case 23:
//        {}break;
//            case 24:
//        {}break;
//        default:
//            break;
//    }
}
-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
   
    
}
-(void)setModel:(NewMainModel *)model
{
    _model = model;
    if(model.is_love ==0)
    {
        [_xiHuanBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
    }
    else if(model.is_love  == 1)
    {
        [_xiHuanBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
    }
    
    if(model.is_collect  ==0)
    {
        [_shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];

    }
    else if(model.is_collect ==1)
    {
        [_shouCangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
        
    }
    [_xiHuanBtn setTitle:[NSString stringWithFormat:@"%zd",model.lovenum] forState:UIControlStateNormal];
    [mainImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.ImageUrl]]];
    [nameLabel setText:model.name];
    [_pingLunBtn setTitle:[NSString stringWithFormat:@"%zd",model.commentnum] forState:UIControlStateNormal];
    
    
   // [nameContent setText:model.titleContent];
    //[numberWatch setText:model.detail];
    
}


@end
