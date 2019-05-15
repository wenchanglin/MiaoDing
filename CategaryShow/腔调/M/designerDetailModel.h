//
//  designerDetailModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/25.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "diyClothesDetailModel.h"
#import "imgListModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface skuOneModel: NSObject
@property(nonatomic,strong)NSString*type;
@property(nonatomic,strong)NSArray*sku;
@end
@interface skuTwoModel: NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*img;
@end
@interface designerDetailModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString*detail;
@property(nonatomic,strong)NSString*content;
@property(nonatomic,strong)NSString*goods_no;
@property(nonatomic,strong)NSString*sell_price;
@property(nonatomic,strong)NSString*moren_fabric_id;
@property(nonatomic,strong)NSString*up_time;
@property(nonatomic,strong)NSArray*ad_img;
@property(nonatomic,strong)NSArray*img_info;
@property(nonatomic,strong)NSString*moren_part_id;
@property(nonatomic,assign)NSInteger category_id;
@property(nonatomic,strong)NSArray*sku;
@property(nonatomic,assign)NSInteger if_liz;
@property(nonatomic,assign)NSInteger collect_num;
@property(nonatomic,strong)NSArray *collect_list;
@end

NS_ASSUME_NONNULL_END
