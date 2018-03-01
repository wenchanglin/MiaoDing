//
//  orderModel.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderModel : NSObject

@property (nonatomic, retain) NSString *number;  //订单编号
@property (nonatomic, retain) NSString *clothesImg;  //衣服图片
@property (nonatomic, retain) NSString *clothesName;  //衣服名字
@property (nonatomic, retain) NSString *clothesPrice;  //衣服价格
@property (nonatomic, retain) NSString *clothesBuyStatus;  //衣服状态
@property (nonatomic, retain) NSString *clothesCount;
@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, assign) NSInteger clothesStatus;

@property (nonatomic, retain) NSString *sizeContnt;


@property (nonatomic, assign) BOOL ifCommend;
@end
