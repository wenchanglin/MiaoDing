//
//  rightCollectionViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "rightCollectionViewCell.h"

@implementation rightCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
        [_imageShow.layer setCornerRadius:_imageShow.frame.size.width / 2];
        [_imageShow.layer setMasksToBounds:YES];
        _imageShow.layer.borderWidth = 1;
        _imageShow.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _bigButoon = [[UIButton alloc] initWithFrame:_imageShow.frame];
        [_bigButoon setUserInteractionEnabled:YES];
       
        
        [self.contentView addSubview:_imageShow];
        
        
        _Alhpa = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
        [_Alhpa setBackgroundColor:[UIColor lightGrayColor]];
        [_Alhpa setAlpha:0.3];
        [_Alhpa.layer setCornerRadius:(self.frame.size.height - 10) / 2];
        [_Alhpa.layer setMasksToBounds:YES];
        [self.contentView addSubview:_Alhpa];
        [_Alhpa setHidden:YES];
         [self.contentView addSubview:_bigButoon];
        
    }
    return self;
}
@end
