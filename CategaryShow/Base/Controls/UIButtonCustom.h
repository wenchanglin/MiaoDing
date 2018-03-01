//
//  UIButtonCustom.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/24.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonCustomType) {
    UIButtonCustomTypeOfHorizontal,
    UIButtonCustomTypeOfVertical
};

@interface UIButtonCustom : UIButton

@property (assign,nonatomic) CGSize sizeImage;

@property (assign,nonatomic) UIButtonCustomType buttonType;

@end
