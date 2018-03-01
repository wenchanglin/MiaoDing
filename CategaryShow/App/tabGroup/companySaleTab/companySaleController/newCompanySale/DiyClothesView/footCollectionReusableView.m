//
//  footCollectionReusableView.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/11.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "footCollectionReusableView.h"

@implementation footCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [UILabel new];
        [self addSubview:label];
        label.sd_layout
        .centerYEqualToView(self)
        .leftSpaceToView(self, 20)
        .widthIs(15)
        .autoHeightRatio(0);
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:[UIColor blackColor]];
        [label setText:@"继续滑动加载更多..."];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
