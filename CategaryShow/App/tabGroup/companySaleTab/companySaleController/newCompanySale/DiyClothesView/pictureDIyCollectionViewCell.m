//
//  pictureDIyCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/11.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "pictureDIyCollectionViewCell.h"

@implementation pictureDIyCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _clothesIntroPic = [UIImageView new];
        [self.contentView addSubview:_clothesIntroPic];
        _clothesIntroPic.contentMode = UIViewContentModeScaleAspectFill;
        [_clothesIntroPic.layer setMasksToBounds:YES];
        _clothesIntroPic.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
