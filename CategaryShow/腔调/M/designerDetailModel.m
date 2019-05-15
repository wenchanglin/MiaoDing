//
//  designerDetailModel.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/25.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "designerDetailModel.h"

@implementation designerDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"ad_img":@"imgListModel",@"img_info":@"imgListModel",@"sku":@"skuOneModel",@"collect_list":@"collect_listModel"};
}
@end
@implementation skuOneModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"sku":@"skuTwoModel"};
}
@end
@implementation skuTwoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
