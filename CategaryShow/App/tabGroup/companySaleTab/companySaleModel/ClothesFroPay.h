//
//  ClothesFroPay.h
//  CategaryShow
//
//  Created by APPLE on 16/10/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClothesFroPay : NSObject
@property(nonatomic,strong)NSDictionary*address_list;
@property(nonatomic,strong)NSArray*car_list;
@property(nonatomic,strong)NSDictionary*lt_arr;
@end
@interface carListModel : NSObject
@property(nonatomic,strong)NSString * cart_id;
@property(nonatomic,strong)NSString*category_id;
@property (nonatomic, retain) NSString *goods_id;
@property (nonatomic, retain) NSString *goods_name;
@property (nonatomic, retain) NSString *goods_num;
@property (nonatomic, retain) NSString *img_info;
@property (nonatomic, retain) NSArray *part;
@property (nonatomic, retain) NSString *re_marks;
@property (nonatomic, retain) NSString *sell_price;
@end
@interface ltArrModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,assign)NSInteger weight;
@property(nonatomic,strong)NSArray*img_list;
@property(nonatomic,assign)NSInteger is_default;
@end
@interface addressListModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString* accept_name;
@property(nonatomic,strong)NSString* zcode;
@property(nonatomic,strong)NSString* phone;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* province;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString* area;
@property(nonatomic,strong)NSString* address;
@end
