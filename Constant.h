//
//  Constant.h
//  CategaryShow
//
//  Created by 文长林 on 2018/2/28.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#define HitoStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//导航栏的高度

#define HitoNavBarHeight 44.0

//iphoneX-SafeArea的高度

#define HitoSafeAreaHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

//分栏+iphoneX-SafeArea的高度

#define HitoTabBarHeight (49+HitoSafeAreaHeight)

//导航栏+状态栏的高度

#define HitoTopHeight (HitoStatusBarHeight + HitoNavBarHeight)
#define KWidth_Scale SCREEN_WIDTH/375
#define AdaptW(value) ceil(value)*KWidth_Scale

#define NavHeight 0
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Font_12  [UIFont fontWithName:@"Futura-Bold" size:12]
#define Font_13  [UIFont fontWithName:@"Futura-Bold" size:13]
#define Font_14  [UIFont fontWithName:@"Futura-Bold" size:14]
#define Font_15  [UIFont fontWithName:@"Futura-Bold" size:15]
#define Font_16  [UIFont fontWithName:@"Futura-Bold" size:16]
#define Font_17  [UIFont fontWithName:@"Futura-Bold" size:17]
#define Font_18  [UIFont fontWithName:@"Futura-Bold" size:18]
#define Font_19  [UIFont fontWithName:@"Futura-Bold" size:19]
#define Font_20  [UIFont fontWithName:@"Futura-Bold" size:20]
#define Font_21  [UIFont fontWithName:@"Futura-Bold" size:21]
#define Font_22  [UIFont fontWithName:@"Futura-Bold" size:22]
#define Font_23  [UIFont fontWithName:@"Futura-Bold" size:23]
#define Font_24  [UIFont fontWithName:@"Futura-Bold" size:24]
#define Font_25  [UIFont fontWithName:@"Futura-Bold" size:25]
#define Font_26  [UIFont fontWithName:@"Futura-Bold" size:26]
//判断设备是否是iPad
#define iPadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//友盟APPkey
#define UManalyseAppKey @"5acad457f29d9835430000ec"
#define URL_YINSIZCURL @"http://www.cloudworkshop.cn/web/jquery-obj/static"

#ifdef DEBUG
#define WCLLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define WCLLog(...)
#endif
#endif /* Constant_h */
