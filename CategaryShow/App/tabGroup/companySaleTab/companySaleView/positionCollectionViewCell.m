//
//  positionCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "positionCollectionViewCell.h"

@implementation positionCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _positionImage = [UIImageView new];
        [self.contentView addSubview:_positionImage];
        _positionImage.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 0)
        .widthIs(50)
        .heightIs(50);
        [_positionImage.layer setCornerRadius:25];
        [_positionImage.layer setMasksToBounds:YES];
        
        
        _chooseImage = [UIImageView new];
        [self.contentView addSubview:_chooseImage];
        _chooseImage.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(self.contentView, 0)
        .widthIs(50)
        .heightIs(50);
        [_chooseImage.layer setCornerRadius:25];
        [_chooseImage.layer setMasksToBounds:YES];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}



@end
