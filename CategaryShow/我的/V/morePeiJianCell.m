//
//  morePeiJianCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/18.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "morePeiJianCell.h"

@implementation morePeiJianCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _nameLabel = [UILabel new];
    _nameLabel.numberOfLines=0;
    _nameLabel.font=[UIFont fontWithName:@"PingFangSC-Light" size:14];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    [self addSubview:_nameLabel];
    _valueLabel = [UILabel new];
    _valueLabel.numberOfLines=0;
    _valueLabel.textAlignment=NSTextAlignmentRight;
    _valueLabel.font=[UIFont fontWithName:@"PingFangSC-Light" size:14];
    _valueLabel.textColor = [UIColor colorWithHexString:@"#4F4F4F"];
    [self addSubview:_valueLabel];
}
-(void)layoutSubviews
{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH/2-30);
    }];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(_nameLabel.mas_centerY);
    }];
    
}
@end
