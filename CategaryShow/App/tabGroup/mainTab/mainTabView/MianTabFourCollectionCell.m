//
//  MianTabFourCollectionCell.m
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MianTabFourCollectionCell.h"

@implementation MianTabFourCollectionCell

-(id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.YJXImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.text = [[UILabel alloc] initWithFrame:CGRectZero];
        self.leftView  = [[UIView alloc] initWithFrame:CGRectZero];
        [_leftView setBackgroundColor:[UIColor lightGrayColor]];
//
        self.topView  = [[UIView alloc] initWithFrame:CGRectZero];
        [_topView setBackgroundColor:[UIColor lightGrayColor]];
        self.rightView  = [[UIView alloc] initWithFrame:CGRectZero];
        [_rightView setBackgroundColor:[UIColor lightGrayColor]];
        self.bowView  = [[UIView alloc] initWithFrame:CGRectZero];
        [_bowView setBackgroundColor:[UIColor lightGrayColor]];
        
        [_leftView setHidden:YES];
        [_rightView setHidden:YES];
        [_topView setHidden:YES];
        [_bowView setHidden:YES];

        
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_text];
        
        [self.contentView addSubview:_leftView];
         [self.contentView addSubview:_topView];
        [self.contentView addSubview:_rightView];
        [self.contentView addSubview:_bowView];
        [self.contentView addSubview:_YJXImage];
        [_YJXImage setHidden:YES];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-10);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
        
    }];
    
    [_YJXImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        
    }];
    [_YJXImage setImage:[UIImage imageNamed:@"YJX"]];
    
    
    [_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@15);
    }];
    
    [_text setFont:[UIFont systemFontOfSize:12]];
    [_text setTextColor:getUIColor(Color_myTabIconTitleColor)];
    
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@(self.frame.size.height));
        make.width.equalTo(@1);
        
        
    }];
    
    [_leftView setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(self.frame.size.width));
        make.height.equalTo(@1);
        
        
    }];
    [_topView setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(self.frame.size.height));
        make.width.equalTo(@1);
        
        
    }];
    
    [_bowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(self.frame.size.width));
        make.height.equalTo(@1);
        
        
    }];
    
    //use the masonry to create the frame.
    
    [self.text setFont:[UIFont systemFontOfSize:13]];
    self.text.backgroundColor = [UIColor whiteColor];
    self.text.textAlignment = NSTextAlignmentCenter;
    [self.text setTextColor:[UIColor blackColor]];
}

@end
