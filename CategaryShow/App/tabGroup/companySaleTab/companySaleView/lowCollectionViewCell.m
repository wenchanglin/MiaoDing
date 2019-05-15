//
//  lowCollectionViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "lowCollectionViewCell.h"

@implementation lowCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        _imageShow = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
//        _imageShow.backgroundColor=[UIColor blueColor];
        _imageShow.contentMode = UIViewContentModeScaleAspectFill;
        [_imageShow.layer setMasksToBounds:YES];
        [self.contentView addSubview:_imageShow];
        
        _Alhpa = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
        [_Alhpa setBackgroundColor:[UIColor lightGrayColor]];
        [_Alhpa setAlpha:0.3];
        [_Alhpa.layer setCornerRadius:(self.frame.size.height - 10) / 2];
        [_Alhpa.layer setMasksToBounds:YES];
        [self.contentView addSubview:_Alhpa];
        [_Alhpa setHidden:YES];
        
        
    }
    return self;
}
@end
