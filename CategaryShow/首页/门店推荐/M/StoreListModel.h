//
//  StoreListModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/13.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreListModel : NSObject
@property(nonatomic)NSInteger ID;
@property(nonatomic)NSInteger account;
@property(nonatomic,strong)NSString * address;
@property(nonatomic)NSInteger c_time;
@property(nonatomic,strong)NSString * email;
@property(nonatomic)NSInteger factory_id;
@property(nonatomic,strong)NSArray * factory_img_arr;
@property(nonatomic,strong)NSString * img;
@property(nonatomic,strong)NSArray * img_info_arr;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger is_love;
@property(nonatomic,strong)NSString * link;
@property(nonatomic,strong)NSString * Latitude;
@property(nonatomic,strong)NSString * longitude;
@property(nonatomic)NSInteger lovenum;
@property(nonatomic)NSInteger phone;
@property(nonatomic)NSInteger pid;
@property(nonatomic)NSInteger pwd;
@property(nonatomic)NSInteger status;
@property(nonatomic)NSInteger type;
@property(nonatomic,strong)NSString * sub_title;
@property(nonatomic,strong)NSString * uname;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * login_ip;
@end
