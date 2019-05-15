//
//  WCLMethodTools.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/11.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,ShoppingCarType) {
    ShoppingCarTypeBuy=1, //1：直接购买 ；2：加入购物车
    ShoppingCarTypeAdd =2,
};
typedef NS_ENUM(NSUInteger,MyCollectType) {
    MyCollectTypeZiXun=1, //1资讯 2商品 3店铺 4设计师
    MyCollectTypeShopping =2,
    MyCollectTypeStore=3,
    MyCollectTypeDesigner=4,
};
@interface WCLMethodTools : NSObject
+ (void)headerRefreshWithTableView:(id )view completion:(void (^)(void))completion;
+ (void)footerRefreshWithTableView:(id )view completion:(void (^)(void))completion;
+ (void)footerAutoGifRefreshWithTableView:(id )view completion:(void (^)(void))completion;
+ (void)footerNormalRefreshWithTableView:(id )view completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
