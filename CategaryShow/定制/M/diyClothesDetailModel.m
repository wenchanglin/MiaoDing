//
//  diyClothesDetailModel.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "diyClothesDetailModel.h"

@implementation diyClothesDetailModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"ad_img":@"imgListModel",@"collect_list":@"collect_listModel",@"img_info":@"imgListModel"};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
@end
@implementation collect_listModel

@end
