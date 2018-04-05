//
//  takePhotoCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "takePhotoCollectionViewCell.h"

@implementation takePhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp
{
    _imagePhoto = [UIImageView new];
    
    [_imagePhoto setContentMode:UIViewContentModeScaleAspectFit];
    [_imagePhoto.layer setMasksToBounds:YES];
    _imagePhoto.userInteractionEnabled = YES;
    [self.contentView addSubview:_imagePhoto];
//    [_imagePhoto setFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [_imagePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

-(void)setModel:(photoModel *)model
{
    _model = model;
    _imagePhoto.center = self.contentView.center;
    _imagePhoto.image = model.photo;
    
}
@end
