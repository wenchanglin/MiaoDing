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
    _firstImageView.layer.cornerRadius = 3;
    _firstImageView.layer.borderWidth =1;
    _firstImageView.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    _firstImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_firstImageView];
    [_firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(SCREEN_WIDTH-24);
    }];
    _nameTextField = [UITextField new];
    _nameTextField.tag = 990;
    _nameTextField.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _nameTextField.placeholder = @"姓名或昵称";
    [_firstImageView addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstImageView.mas_left).offset(26);
        make.centerY.equalTo(_firstImageView.mas_centerY);
        make.right.equalTo(_firstImageView);
    }];
    _secondImageView = [UIImageView new];
    _secondImageView.userInteractionEnabled =YES;
    _secondImageView.layer.cornerRadius = 3;
    _secondImageView.layer.borderWidth =1;
    _secondImageView.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    _secondImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_secondImageView];
    [_secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstImageView.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(SCREEN_WIDTH/2-14);
    }];
    _cmLabel = [UILabel new];
    _cmLabel.text = @"CM";
    _cmLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _cmLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [_secondImageView addSubview:_cmLabel];
    [_cmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_secondImageView.mas_right).offset(-38);
        make.centerY.equalTo(_secondImageView.mas_centerY);
    }];
    _heightTextField = [UITextField new];
    _heightTextField.keyboardType = UIKeyboardTypeNumberPad;
    _heightTextField.tag = 991;
    _heightTextField.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _heightTextField.placeholder = @"净身高";
    [_secondImageView addSubview:_heightTextField];
    [_heightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_secondImageView.mas_left).offset(26);
        make.centerY.equalTo(_secondImageView.mas_centerY);
        make.right.equalTo(_secondImageView);
    }];
    _thirdImageView = [UIImageView new];
    _thirdImageView.userInteractionEnabled =YES;
    _thirdImageView.layer.cornerRadius = 3;
    _thirdImageView.layer.borderWidth =1;
    _thirdImageView.layer.borderColor = [UIColor colorWithHexString:@"#979797"].CGColor;
    _thirdImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_thirdImageView];
    [_thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondImageView);
        make.left.equalTo(_secondImageView.mas_right).offset(7);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(SCREEN_WIDTH/2-17);
    }];
    
   
    _kgLabel = [UILabel new];
    _kgLabel.text = @"KG";
    _kgLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _kgLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    [_thirdImageView addSubview:_kgLabel];
    [_kgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_thirdImageView.mas_right).offset(-38);
        make.centerY.equalTo(_thirdImageView.mas_centerY);
    }];
    _weightTextField = [UITextField new];
    _weightTextField.tag = 992;
    _weightTextField.keyboardType = UIKeyboardTypeNumberPad;
    // [_weightTextField addTarget:self action:@selector(weighttextfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _weightTextField.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    _weightTextField.placeholder = @"净体重";
    [_thirdImageView addSubview:_weightTextField];
    [_weightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_thirdImageView.mas_left).offset(26);
        make.centerY.equalTo(_thirdImageView.mas_centerY);
        make.right.equalTo(_thirdImageView);
    }];
}
-(void)weighttextfieldDidChange:(UITextField *)textfield
{
    WCLLog(@"%@",textfield.text);
}
@end
