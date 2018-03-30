//
//  mainClothesSaleCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "mainClothesSaleCollectionViewCell.h"
#import "NSObject+LZSwipeCategory.h"
@implementation mainClothesSaleCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    UIView *contentView = self.contentView;
    
    UIImageView *shadowView = [UIImageView new];
    shadowView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [contentView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
//    [shadowView setImage:[UIImage imageNamed:@"slideBack"]];
  
    
    
    
    
//    _imageDesigner = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
//    [shadowView addSubview:_imageDesigner];
//    
//    [_imageDesigner.layer setCornerRadius:2];
//    [_imageDesigner.layer setMasksToBounds:YES];
//    [_imageDesigner setContentMode:UIViewContentModeScaleAspectFill];
    
    _imageDesigner = [UIImageView new];
    
    [shadowView addSubview:_imageDesigner];
    [_imageDesigner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.bottom.mas_equalTo(-12);
    }];
//    _imageDesigner.sd_layout
//    .centerXEqualToView(shadowView)
//    .centerYEqualToView(shadowView)
//    .widthIs(169.5)
//    .heightIs(105);
    [_imageDesigner.layer setCornerRadius:3];
    [_imageDesigner.layer setMasksToBounds:YES];
    
//    _nameLabel = [UILabel new]; 
//    [shadowView addSubview:_nameLabel];
//    _nameLabel.sd_layout
//    .rightSpaceToView(_imageDesigner, 10)
//    .leftSpaceToView(shadowView, 20)
//    .centerYEqualToView(shadowView)
//    .heightIs(20);
//    [_nameLabel setFont:[UIFont boldSystemFontOfSize:18]];
//    [_nameLabel setTextColor:[UIColor blackColor]];
//    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    
}


@end
