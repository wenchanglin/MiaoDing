//
//  BaseTextField.m
//  TakeAuto
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//
#import "Masonry.h"
#import "BaseTextField.h"

@implementation BaseTextField

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.topLine = [[UIView alloc] init];
        [_topLine setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_topLine];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@0.5);
        }];
        
        self.detailField = [[UITextField alloc] init];
        [_detailField setBackgroundColor:[UIColor whiteColor]];
        [self setTextFieldLeftPadding:_detailField forWidth:15];
        [_detailField setLeftViewMode:UITextFieldViewModeAlways];
        [self addSubview:_detailField];
        [_detailField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0.5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).with.offset(-0.5);
        }];
        
        self.bottomLine = [[UIView alloc] init];
        [_bottomLine setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_detailField.mas_bottom);
            make.left.equalTo(_detailField.mas_left);
            make.right.equalTo(_detailField.mas_right);
            make.height.equalTo(@0.5);
        }];

        
        
        
    }
    return self;
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

@end
