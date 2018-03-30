//
//  StoresDetailModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoresDetailModel : NSObject
@property(nonatomic,strong)NSString * Latitude;
@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)NSString *bgimg;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSArray * img_info;
@property(nonatomic,strong)NSString * login_ip;
@property(nonatomic,strong)NSString *longitude;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *uname;
@property(nonatomic,strong)NSArray * data_img;
@property(nonatomic,strong)NSArray * factory_img_arr;
@property(nonatomic,strong)NSArray * img_info_arr;

@property(nonatomic)NSInteger account;
@property(nonatomic)NSInteger c_time;
@property(nonatomic)NSInteger factory_id;
@property(nonatomic)NSInteger ID;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger is_love;
@property(nonatomic)NSInteger lovenum;
@property(nonatomic)NSInteger phone;
@property(nonatomic)NSInteger pid;
@property(nonatomic)NSInteger pwd;
@property(nonatomic)NSInteger status;
@property(nonatomic)NSInteger type;
@end
