//
//  orderModel.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myBagModel.h"
@interface orderModel : NSObject
@property (nonatomic, retain) NSString *order_sn;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString *real_amount;
@property (nonatomic, retain) NSString *payable_amount;
@property (nonatomic, retain) NSString *giftcard_eq_money;
@property (nonatomic, retain) NSString *status_text;
@property (nonatomic, strong) NSArray *childOrders;
/**
 物流单号
 */
@property (nonatomic, retain) NSString *express_no;

@end
@interface childOrdersModel : NSObject
@property (nonatomic, retain) NSString *detail_order_sn;
@property (nonatomic, retain) NSString *sell_price;
@property (nonatomic, assign) NSInteger goods_id;
@property (nonatomic, retain) NSString *goods_name;
@property (nonatomic, assign) NSInteger goods_num;
@property (nonatomic, retain) NSString *img_info;
@property (nonatomic, retain) NSString *re_marks;
@property (nonatomic, assign) NSInteger category_id;
@property(nonatomic,strong)NSString* sizeOrDing;
@property(nonatomic,strong)NSArray*part;
@property(nonatomic,strong)NSArray*sku;
@end

