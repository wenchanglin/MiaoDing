//
//  orderModel.m
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "orderModel.h"

@implementation orderModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"childOrders":@"childOrdersModel"};
}
@end
@implementation childOrdersModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"part":@"partModel",@"sku":@"skuModel"};
}
Description
@end

