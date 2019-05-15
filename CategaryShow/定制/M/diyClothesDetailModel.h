//
//  diyClothesDetailModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface collect_listModel : NSObject
@property(nonatomic,strong)NSString*head_ico;
@property(nonatomic,strong)NSString*uid;
@property(nonatomic,strong)NSString*username;
@end
@interface diyClothesDetailModel : NSObject
@property(nonatomic,strong)NSArray*ad_img;
@property(nonatomic,strong)NSString*category_name;
@property(nonatomic,strong)NSArray*collect_list;
@property(nonatomic,strong)NSString*collect_num;
@property(nonatomic,strong)NSString*content;
@property(nonatomic,strong)NSString*goods_no;
@property(nonatomic,strong)NSArray*img_info;
@property(nonatomic,strong)NSString*is_collect;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*sell_price;
@property(nonatomic,strong)NSString*up_time;
@property(nonatomic,assign)NSInteger ID;

@end
