//
//  sizeAndColorCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "sizeAndColorCollectionViewCell.h"

@implementation sizeAndColorCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _sizeAndColorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 17.5, self.frame.size.height / 2 - 17.5, 35 , 35)];
        [_sizeAndColorLabel.layer setCornerRadius:17.5];
        [_sizeAndColorLabel.layer setMasksToBounds:YES];
        [_sizeAndColorLabel setFont:Font_12];
        [_sizeAndColorLabel setTextAlignment:NSTextAlignmentCenter];
        [_sizeAndColorLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_sizeAndColorLabel];
        
        
        _colorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 17.5, self.frame.size.height / 2 - 17.5, 35 , 35)];
        [_colorImg.layer setCornerRadius:17.5];
        [_colorImg.layer setMasksToBounds:YES];
        [self.contentView addSubview:_colorImg];
        [_colorImg.layer setBorderWidth:1];
        [_colorImg.layer setBorderColor:[UIColor blackColor].CGColor];
        
        
        _whiteAlpha = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 17.5, self.frame.size.height / 2 - 17.5, 35 , 35)];
        [_whiteAlpha.layer setCornerRadius:17.5];
        [_whiteAlpha.layer setMasksToBounds:YES];
        [_whiteAlpha setImage:[UIImage imageNamed:@"whiteAlpha"]];
        [self.contentView addSubview:_whiteAlpha];
        
    }
    
    return self;
}

@end
