//
//  NewDesignerModel.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/10.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "NewDesignerModel.h"

@implementation NewDesignerModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"goods_list":@"DesignerGoodsListModel"};
}
@end
@implementation DesignerGoodsListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodsListId":@"id"};
}

@end
