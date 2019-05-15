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
    UIButton*xinpinBtn;
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
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(12);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(20);
    }];
    
    tagLabel = [UILabel new];
    tagLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    tagLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
    [bgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
        make.left.equalTo(titleLabel);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(17);
    }];
    priceLabel = [UILabel new];
    priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagLabel.mas_bottom).offset(2);
        make.right.mas_equalTo(-9);
        make.left.equalTo(titleLabel);
    }];
    xinpinBtn = [UIButton new];
    [xinpinBtn setTitle:@"新品" forState:UIControlStateNormal];
    xinpinBtn.layer.cornerRadius=2;
    xinpinBtn.layer.masksToBounds=YES;
    [xinpinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    xinpinBtn.titleLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:8];
    xinpinBtn.backgroundColor = [UIColor colorWithHexString:@"#D9C38A"];
    [bgView addSubview:xinpinBtn];
    [xinpinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(12);
    }];
    
}

-(void)setModel:(chageDiyModel *)model
{
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.ad_img]]];
    [titleLabel setText:model.name];
    [tagLabel setText:model.content];
    priceLabel.text = model.sell_price;
    if(model.is_new==1)
    {
        xinpinBtn.hidden=NO;
    }
    else
    {
        xinpinBtn.hidden=YES;
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    

}


@end
