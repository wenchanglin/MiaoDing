//
//  HeightAndWeightCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/3.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "HeightAndWeightCell.h"

@implementation HeightAndWeightCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _firstImageView = [UIImageView new];
    _firstImageView.userInteractionEnabled =YES;
    _firstImageView.image = [UIImage imageNamed:@"font"];
    [self.contentView addSubview:_firstImageView];
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(SCREEN_WIDTH/2-17);
    }];
   
    _cmLabel = [UILabel new];
    _cmLabel.text = @"CM";
    _cmLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _cmLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [_firstImageView addSubview:_cmLabel];
    [_cmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_firstImageView.mas_right).offset(-38);
        make.centerY.equalTo(_firstImageView.mas_centerY);
    }];
    _heightTextField = [UITextField new];
    _heightTextField.keyboardType = UIKeyboardTypeNumberPad;
    _heightTextField.tag = 991;
    _heightTextField.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _heightTextField.placeholder = @"净身高";
    [_firstImageView addSubview:_heightTextField];
    [_heightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstImageView.mas_left).offset(26);
        make.centerY.equalTo(_firstImageView.mas_centerY);
        make.right.equalTo(_firstImageView);
    }];
    _secondImageView = [UIImageView new];
    _secondImageView.userInteractionEnabled =YES;
    _secondImageView.image = [UIImage imageNamed:@"font"];
    [self.contentView addSubview:_secondImageView];
    [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.equalTo(_firstImageView.mas_right).offset(7);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(SCREEN_WIDTH/2-17);
    }];
    
   
    _kgLabel = [UILabel new];
    _kgLabel.text = @"KG";
    _kgLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _kgLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [_secondImageView addSubview:_kgLabel];
    [_kgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_secondImageView.mas_right).offset(-38);
        make.centerY.equalTo(_secondImageView.mas_centerY);
    }];
    _weightTextField = [UITextField new];
    _weightTextField.tag = 992;
    _weightTextField.keyboardType = UIKeyboardTypeNumberPad;
    // [_weightTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _weightTextField.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _weightTextField.placeholder = @"净体重";
    [_secondImageView addSubview:_weightTextField];
    [_weightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_secondImageView.mas_left).offset(26);
        make.centerY.equalTo(_secondImageView.mas_centerY);
        make.right.equalTo(_secondImageView);
    }];
}
-(void)weighttextfieldDidChange:(UITextField *)textfield
{
    WCLLog(@"%@",textfield.text);
}
@end
