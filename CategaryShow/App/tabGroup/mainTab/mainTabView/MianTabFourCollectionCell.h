//
//  MianTabFourCollectionCell.h
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MianTabFourCollectionCell : UICollectionViewCell

@property(nonatomic ,strong)UIImageView *imgView;   //show the image

@property(nonatomic ,strong)UILabel *text;          // show the title

@property (nonatomic, retain) UIImageView *YJXImage;

@property (nonatomic, retain) UIView *leftView;  //分割线

@property ( nonatomic, retain) UIView *topView;  //上分隔线

@property (nonatomic, retain) UIView *rightView; //右分割线

@property (nonatomic, retain) UIView *bowView;  //下分割线

@end
