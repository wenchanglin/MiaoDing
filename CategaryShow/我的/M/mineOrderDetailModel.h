//
//  mineOrderDetailModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/23.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "orderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface mineOrderDetailModel : NSObject
@property(nonatomic,strong)NSString*currentTimeStr;//当前时间戳
@property(nonatomic,strong)NSString* order_sn;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSString*real_amount;
@property(nonatomic,strong)NSString*order_amount;
@property(nonatomic,strong)NSString*giftcard_eq_money;
@property(nonatomic,strong)NSString*ticket_reduce_money;
@property(nonatomic,strong)NSString*payable_amount;
@property(nonatomic,strong)NSString*discount;
@property(nonatomic,strong)NSString*promotions;
@property(nonatomic,strong)NSString*province;
@property(nonatomic,strong)NSString*city;
@property(nonatomic,strong)NSString*area;
@property(nonatomic,strong)NSString*address;
@property(nonatomic,strong)NSString*accept_name;
@property(nonatomic,strong)NSString*address_phone;
@property(nonatomic,strong)NSString*real_freight;
@property(nonatomic,strong)NSString*pay_type;
@property(nonatomic,strong)NSString*pay_time;
@property(nonatomic,strong)NSString*create_time;
@property(nonatomic,strong)NSString*express_no;
@property(nonatomic,strong)NSString*status_text;
@property(nonatomic,assign)NSInteger pay_count_down_time;
@property (nonatomic, strong) NSArray *childOrders;
@end

NS_ASSUME_NONNULL_END
