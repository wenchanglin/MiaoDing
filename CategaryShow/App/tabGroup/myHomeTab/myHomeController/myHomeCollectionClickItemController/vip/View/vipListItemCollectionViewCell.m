//
//  vipListItemCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/16.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "vipListItemCollectionViewCell.h"

@implementation vipListItemCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        self.text = [[UILabel alloc] initWithFrame:CGRectZero];
        
        
    
        
        
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_text];
        
        
        
        // the frame should be seted in layoutsubviews,but should set cgrectzero to subview
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(10);
        make.width.equalTo(@45);
        make.height.equalTo(@45);
        
    }];
    
    [_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).with.offset(11);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@15);
    }];
    
    [_text setFont:[UIFont systemFontOfSize:12]];
    [_text setTextColor:getUIColor(Color_myTabIconTitleColor)];
    
    
    
    //use the masonry to create the frame.
    
    [self.text setFont:[UIFont systemFontOfSize:12]];
    self.text.backgroundColor = [UIColor whiteColor];
    self.text.textAlignment = NSTextAlignmentCenter;
    [self.text setTextColor:[UIColor blackColor]];
}

@end
