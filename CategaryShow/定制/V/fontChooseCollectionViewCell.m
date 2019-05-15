//
//  fontChooseCollectionViewCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/14.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "fontChooseCollectionViewCell.h"

@implementation fontChooseCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UIImageView *img = [[UIImageView alloc] init];
    img.contentMode=UIViewContentModeScaleAspectFill;
    [img.layer setMasksToBounds:YES];
    [self addSubview:img];
    _fontImageView=img;
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(122);
    }];
    _fontChoose = [UIImageView new];
    [self.contentView addSubview:_fontChoose];
    [_fontChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_top).offset(-10);
        make.centerX.equalTo(img.mas_centerX);
        make.height.width.equalTo(img);
    }];
    UILabel *labelName = [[UILabel alloc] init];
    [labelName setTextAlignment:NSTextAlignmentCenter];
    [labelName setFont:[UIFont systemFontOfSize:12]];
    [labelName setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:labelName];
    _fontLabel=labelName;
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(-5);
        make.centerX.equalTo(img.mas_centerX);
        make.width.height.equalTo(img);
    }];
}
@end
