//
//  LiangTiOneRowReusableView.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/30.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "LiangTiOneRowReusableView.h"

@implementation LiangTiOneRowReusableView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(81);
            make.width.mas_equalTo(102);
        }];
        [self.noteLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView.mas_bottom).offset(30);
            make.left.mas_equalTo(35);
            make.right.mas_equalTo(-35);
        }];
        [self.noteLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.equalTo(self.noteLabel1.mas_bottom).offset(40);
            make.right.mas_equalTo(-35);
        }];
    }
    return self;
}
-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.contentMode=UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds=YES;
        _headImageView.image=[UIImage imageNamed:@"xingtiplace"];
        [self addSubview:_headImageView];
    }
    return _headImageView;
}
-(UILabel *)noteLabel1
{
    if (!_noteLabel1) {
        _noteLabel1= [UILabel new];
        _noteLabel1.textAlignment=NSTextAlignmentCenter;
        _noteLabel1.font=[UIFont systemFontOfSize:11];
        _noteLabel1.text =@"根据您的形体数据，未找到合适的成衣，请尝试妙定量体定制";
        _noteLabel1.textColor = [UIColor colorWithHexString:@"#7E818C"];
        [self addSubview:_noteLabel1];
    }
    return _noteLabel1;
}
-(UILabel *)noteLabel2
{
    if (!_noteLabel2) {
        _noteLabel2= [UILabel new];
        _noteLabel2.font=[UIFont systemFontOfSize:14];
        _noteLabel2.text =@"您的量体数据:";
        _noteLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_noteLabel2];
    }
    return _noteLabel2;
}
@end
