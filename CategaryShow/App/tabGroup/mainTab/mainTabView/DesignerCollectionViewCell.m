//
//  DesignerCollectionViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DesignerCollectionViewCell.h"

@implementation DesignerCollectionViewCell


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
    
    UIView *shadowView = [UIView new];
    [contentView addSubview:shadowView];
    shadowView.sd_layout
    .leftSpaceToView(contentView, 5)
    .rightSpaceToView(contentView, 5)
    .topSpaceToView(contentView, 10)
    .bottomSpaceToView(contentView, 10);
    [[shadowView layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
    [[shadowView layer] setShadowRadius:3];                // 阴影扩散的范围控制
    [[shadowView layer] setShadowOpacity:0.5];               // 阴影透明度
    [[shadowView layer] setShadowColor:[UIColor grayColor].CGColor];
    
    
    
    
    UIView *bgView = [UIView new];
    [shadowView addSubview:bgView];
    bgView.sd_layout
    .leftEqualToView(shadowView)
    .rightEqualToView(shadowView)
    .topEqualToView(shadowView)
    .bottomEqualToView(shadowView);
    [bgView.layer setCornerRadius:3];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    bgView.layer.masksToBounds = YES;
    
    
    
    
    _imageDesigner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.width - 10)];
    [bgView addSubview:_imageDesigner];
    
    [_imageDesigner.layer setCornerRadius:2];
    [_imageDesigner.layer setMasksToBounds:YES];
    [_imageDesigner setContentMode:UIViewContentModeScaleAspectFill];
    
    
   
    
    UIView *nameShadowView = [UIView new];
    [bgView addSubview:nameShadowView];
    nameShadowView.sd_layout
    .leftSpaceToView(bgView, 18)
    .rightSpaceToView(bgView, 18)
    .topSpaceToView(_imageDesigner, -13)
    .heightIs(26);
    [[nameShadowView layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
    [[nameShadowView layer] setShadowRadius:3];                // 阴影扩散的范围控制
    [[nameShadowView layer] setShadowOpacity:0.5];               // 阴影透明度
    [[nameShadowView layer] setShadowColor:[UIColor grayColor].CGColor];
    
    _name = [UILabel new];
    [nameShadowView addSubview:_name];
    _name.sd_layout
    .leftEqualToView(nameShadowView)
    .rightEqualToView(nameShadowView)
    .topEqualToView(nameShadowView)
    .heightIs(26);
    [_name setBackgroundColor:[UIColor whiteColor]];
    [_name.layer setCornerRadius:11.5];
    _name.layer.masksToBounds = YES;
    [_name setFont:Font_14];
    [_name setTextAlignment:NSTextAlignmentCenter];
    
    _detail = [UILabel new];
    [bgView addSubview:_detail];
    _detail.sd_layout
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .topSpaceToView(nameShadowView, 9)
    .heightIs(17);
    [_detail setFont:[UIFont systemFontOfSize:12]];
    [_detail setTextColor:getUIColor(Color_DesignerTag)];
    [_detail setTextAlignment:NSTextAlignmentCenter];
    
    
}

//-(void)setDesigner:(NewMainDesigner *)designer
//{
//    _designer = designer;
//    [imageDesigner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,designer.imgUrl]]];
//    [name setText:designer.name];
//    [detail setText:designer.tagInfo];
//    
//}


@end
