//
//  newDiyAllDataModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/12.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "imgListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface newDiyAllDataModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*content;
@property(nonatomic,strong)NSString*goods_no;
@property(nonatomic,strong)NSString*sell_price;
@property(nonatomic,strong)NSString*moren_fabric_id;
@property(nonatomic,strong)NSString*up_time;
@property(nonatomic,strong)NSString*moren_part_id;
@property(nonatomic,strong)NSString*fabric_stock_name;
@property(nonatomic,strong)NSString*fabric_stock_num;
@property(nonatomic,assign)NSInteger if_liz;
@property(nonatomic,strong)NSString*collect_num;
@property(nonatomic,strong)NSArray*ad_img;
@property(nonatomic,strong)NSArray*img_info;
@property(nonatomic,strong)NSArray*series;
@property(nonatomic,strong)NSArray*fabric;
@property(nonatomic,strong)NSArray*must_display_part;
@property(nonatomic,strong)NSArray*special_mark_part;
@property(nonatomic,strong)NSArray*category;
@property(nonatomic,strong)NSArray*collect_list;
@end
@interface secondDataModel : NSObject
@property(nonatomic,assign)NSInteger type_id;
@property(nonatomic,strong)NSString*type_name;
@property(nonatomic,assign)NSInteger img_mark;
@property(nonatomic,strong)NSString*android_min;
@property(nonatomic,assign)NSInteger special_mark;
@property(nonatomic,strong)NSString*mutex_part;
@property(nonatomic,strong)NSArray*son;
@end
@interface threeDataModel : NSObject
@property(nonatomic,assign)NSInteger part_id;
@property(nonatomic,strong)NSString*part_name;
@property(nonatomic,assign)NSInteger is_default;
@property(nonatomic,strong)NSString*part_img;
@property(nonatomic,strong)NSString* android_min;
@property(nonatomic,strong)NSString*android_middle;
@property(nonatomic,strong)NSString*android_max;
@property(nonatomic,strong)NSString*mutex_part;
@property(nonatomic,strong)NSArray*child_list;
@end
NS_ASSUME_NONNULL_END
