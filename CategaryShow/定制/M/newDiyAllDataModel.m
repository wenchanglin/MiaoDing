//
//  newDiyAllDataModel.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/12.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "newDiyAllDataModel.h"
#import "newDiyMianLiaoModel.h"
@implementation newDiyAllDataModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"ad_img":@"imgListModel",@"fabric":@"newDiyMianLiaoModel",@"img_info":@"imgListModel",@"must_display_part":@"secondDataModel",@"special_mark_part":@"secondDataModel"};
}
Description
@end
@implementation secondDataModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"son":@"threeDataModel"};
}
Description
@end
@implementation threeDataModel
Description


@end
