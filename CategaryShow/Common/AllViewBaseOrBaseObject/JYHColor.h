//
//  JYHColor.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/1/12.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#ifndef CongestionOfGod_JYHColor_h
#define CongestionOfGod_JYHColor_h


#endif


/*!
 @discussion NavBar背景色
 */
#define Color_background 0xf2f2f2
#define Color_mainColor 0xcacaca
#define Color_grayWord 0x5a5a5a
#define Color_buyColor 0x232323
#define Color_saveColor 0xbdbdbd

#define Color_BuyLineColor 0xe8e8e8
#define Color_myTabIconLineColor 0xf1f1f1
#define Color_myTabIconTitleColor 0x202020
#define Color_mainCollectionColor 0xefeff4
#define Color_myEmptySave 0xdbdbdb
#define Color_measureTableTitle 0x363636
#define Color_suggestLargeTitle 0x3a3a3a
#define Color_suggestSmallTitle 0x6d6d6d
#define Color_loginBackViewColor 0xe5e5e5
#define Color_loginNoUserName 0x999999
#define Color_loginHaveName 0x333333
#define Color_loginText 0x666666

#define Color_myOrderLine 0xf0f0f0
#define Clolor_myOrderClothesCount 0xb6b6b6
#define Color_myOrderPayForAndPrice 0xe73936
#define Color_myOrderBack 0xf6f6f6
#define Color_myBagToPayButton 0x222222
#define Color_myBagPrice 0xeb5351
#define Color_myBagUpdate 0xaaaaaa
#define Color_WearClothesPlaceHolder 0xc1c1c6
#define Color_ClothesPayPrice 0xea3a37
#define Color_Share 0xf6f6f6
#define Color_lightGrayLine 0xCECECE
#define Color_ShareBack 0x000000
#define Color_ShareTitle 0x2a2a2a

#define Color_invitBack 0xf9f9f9
#define Color_active 0x505050

#define Color_DataColor 0xF2F2F2

#define COLOR_VipLeft 0xefab1f
#define COLOR_TAB 0xe6e6e6
#define COLOR_TABTEX 0x006aa7
#define Color_graytext 0x4D4D4D
#define Color_tabbartextcolor 0x7D8393
#define Color_payViewLine 0xdadada
#define Color_RuleDetail 0x8f8f8f

#define Color_DesignerBack 0xf3f3f3

//new
#define Color_shadow 0xFFFFFF
#define Color_numberWatch 0x939393
#define Color_DesignerTag 0x717171
#define Color_DZClolor 0x3d3d3d

#define Color_TKClolor 0x222222
#define Color_AddBag 0x4c4c4c
#define Color_DesignerTagClolor 0x222223
#define Color_circle 0xe1e1e1
#define Color_grayColorForDesigner 0x333333
#define Color_introduce 0x4f4f4f
#define Color_clothDiyBack 0xfbfbfb
#define ColorOrderGray 0x707070

/*!
 @method getColorP(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result P / 255.0
 */
static inline float getColorP(int intColor){
    return 1.0 - ((intColor & 0xFF000000)>> 0x18) / 255.0f;
}

/*!
 @method getColorR(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result R / 255.0
 */
static inline float getColorR(int intColor){
    return ((intColor & 0x00FF0000) >> 0x10 ) / 255.0f;
}

/*!
 @method getColorG(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result G / 255.0
 */
static inline float getColorG(int intColor) {
    return ((intColor & 0x0000FF00) >> 0x08 ) / 255.0f;
}

/*!
 @method getColorB(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result B / 255.0
 */
static inline float getColorB(int intColor) {
    return (intColor & 0x000000FF) / 255.0f;
}


/*!
 @method getColorP(int intColor)
 @abstract 得到RGB颜色值中的R值
 @discussion 得到RGB颜色值中的R值。
 @param intColor 颜色值
 @result P / 255.0
 */
static inline UIColor* getUIColor(int intColor){
    
    return [UIColor colorWithRed:getColorR(intColor) green:getColorG(intColor) blue:getColorB(intColor) alpha:getColorP(intColor)];
}
