//
//  changeDiyCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/26.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "changeDiyCollectionViewCell.h"

@implementation changeDiyCollectionViewCell
{
    UIImageView *bgView;
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *tagLabel;
    UILabel * priceLabel;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIView *contentView = self.contentView;
    bgView = [UIImageView new];
    [contentView addSubview:bgView];
    // [bgView setImage:[UIImage imageNamed:@"kapian"]];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-9.2);
    }];
    
    imgView = [UIImageView new];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [imgView.layer setMasksToBounds:YES];
    [bgView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.bottom.equalTo(bgView.mas_bottom).offset(-73.8);
    }];
    
    titleLabel = [UILabel new];
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bgView addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(12);
        make.left.mas_equalTo(9);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(20);
    }];
    
    tagLabel = [UILabel new];
    tagLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    tagLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    [bgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(titleLabel);
        make.height.mas_equalTo(17);
    }];
    priceLabel = [UILabel new];
    priceLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.centerY.equalTo(tagLabel.mas_centerY);
    }];
}

-(void)setModel:(chageDiyModel *)model
{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img_new]]];
    [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.height.mas_equalTo((SCREEN_WIDTH / 2 - 6)/[model.img_info floatValue]);
    }];
    [titleLabel setText:model.name];
    [tagLabel setText:model.sub_name];
    priceLabel.text = model.price;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    

}


@end
