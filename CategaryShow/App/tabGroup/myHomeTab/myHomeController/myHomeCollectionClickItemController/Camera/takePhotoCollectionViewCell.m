//
//  takePhotoCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "takePhotoCollectionViewCell.h"

@implementation takePhotoCollectionViewCell
{
    UIImageView *imagePhoto;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp
{
    imagePhoto = [UIImageView new];
    
    [imagePhoto setFrame:CGRectMake(0, 0, self.frame.size.height / 4416.0 * 2800.0 , self.frame.size.height)];
    [imagePhoto setContentMode:UIViewContentModeScaleAspectFit];
    [imagePhoto.layer setMasksToBounds:YES];
    [self.contentView addSubview:imagePhoto];
    
}

-(void)setModel:(photoModel *)model
{
    _model = model;
    imagePhoto.center = self.contentView.center;
    imagePhoto.image = model.photo;
    
}
@end
