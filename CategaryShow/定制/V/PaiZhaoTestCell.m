//
//  PaiZhaoTestCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/4.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "PaiZhaoTestCell.h"

@implementation PaiZhaoTestCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _photoImageView = [UIButton new];
    [_photoImageView setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
    [self.contentView addSubview:_photoImageView];
    _photoImageView.sd_layout.topSpaceToView(self.contentView, 12).leftSpaceToView(self.contentView, 26).heightIs(60).widthIs(60);
    [_photoImageView.layer setCornerRadius:30];
    [_photoImageView.layer setMasksToBounds:YES];
    _shuomingLabel = [UILabel new];
    _shuomingLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    _shuomingLabel.textColor = [UIColor colorWithHexString:@"#979797"];
    _shuomingLabel.text = @"沿顺时针方向旋转完成身体四个面的拍摄";
    [self.contentView addSubview:_shuomingLabel];
    [_shuomingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoImageView.mas_right).offset(24);
        make.centerY.equalTo(_photoImageView.mas_centerY);
        make.right.mas_equalTo(-10);
    }];
}

@end
