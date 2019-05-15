//
//  RecommendToYouHeadView.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/26.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "RecommendToYouHeadView.h"

@implementation RecommendToYouHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self.titleLabels mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(39);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(22);
        }];
        [self.fenGeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabels);
            make.left.equalTo(self.titleLabels.mas_right).offset(7);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}
-(UILabel *)titleLabels
{
    if (!_titleLabels) {
        _titleLabels = [UILabel new];
        _titleLabels.text=@"为你推荐";
        _titleLabels.textColor = [UIColor colorWithHexString:@"#202020"];
        _titleLabels.font = [UIFont fontWithName:@"PingFangTC-Regular" size:16];
        [self addSubview:_titleLabels];
    }
    return _titleLabels;
}
-(UIView *)fenGeView
{
    if (!_fenGeView) {
        _fenGeView = [UIView new];
        _fenGeView.backgroundColor=[UIColor colorWithRed:32/255 green:32/255 blue:32/255 alpha:.13];
        [self addSubview:_fenGeView];
    }
    return _fenGeView;
}
@end
