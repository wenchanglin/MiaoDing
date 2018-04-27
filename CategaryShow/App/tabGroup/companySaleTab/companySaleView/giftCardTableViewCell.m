//
//  giftCardTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "giftCardTableViewCell.h"

@implementation giftCardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _msimageView =[UIImageView new];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [_msimageView addGestureRecognizer:tap];
        _msimageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_msimageView];
        [_msimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
            make.top.bottom.equalTo(self.contentView);
        }];
//        _lastMoney = [UILabel new];
//        [_lastMoney setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
//        _lastMoney.textColor = [UIColor colorWithHexString:@"#222222"];
//        [_msimageView addSubview:_lastMoney];

        _chooseImage = [UIButton new];
        _chooseImage.titleLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:14];
        [_chooseImage setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        [_msimageView addSubview:_chooseImage];
        [_chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.height.width.mas_equalTo(14);
        }];
//        [_lastMoney mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_chooseImage.mas_right).offset(5);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.height.mas_equalTo(20);
//        }];
      
       
        
        
    }
    return self;
}
-(void)tap:(UITapGestureRecognizer *)tap
{
//    _DesignerInfo(tap);
//        WCLLog(@"你点击了我");
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
