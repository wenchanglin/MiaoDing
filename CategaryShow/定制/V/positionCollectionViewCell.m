//
//  positionCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "positionCollectionViewCell.h"

@implementation positionCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _positionImage = [UIImageView new];
        [self.contentView addSubview:_positionImage];
        [_positionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.width.mas_equalTo(60);
        }];
        [_positionImage.layer setCornerRadius:30];
        [_positionImage.layer setMasksToBounds:YES];
        _positionImage.layer.borderWidth =1;
        
        _chooseImage = [UIImageView new];
        [self.contentView addSubview:_chooseImage];
        _chooseImage.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 0)
        .widthIs(60)
        .heightIs(60);
        [_chooseImage.layer setCornerRadius:30];
        [_chooseImage.layer setMasksToBounds:YES];
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_positionImage.mas_centerX);
            make.top.equalTo(_positionImage.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}



@end
