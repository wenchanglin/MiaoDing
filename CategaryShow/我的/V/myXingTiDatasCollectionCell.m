//
//  myXingTiDatasCollectionCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/30.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "myXingTiDatasCollectionCell.h"

@implementation myXingTiDatasCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
//            make.right.mas_equalTo(-27);
        }];
    }
    return self;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel =[UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font=[UIFont systemFontOfSize:14];
        _nameLabel.numberOfLines=1;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel =[UILabel new];
        _valueLabel.textColor = [UIColor blackColor];
        _valueLabel.font=[UIFont systemFontOfSize:14];
        _valueLabel.numberOfLines=1;
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

@end
