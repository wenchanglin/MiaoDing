//
//  ZiXunModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/15.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiXunModel : NSObject
@property(nonatomic)NSInteger c_time;
@property(nonatomic)NSInteger commentnum;
@property(nonatomic)NSInteger ID;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic) NSInteger is_love;
@property(nonatomic) NSInteger is_type;
@property(nonatomic) NSInteger like_nums;
@property(nonatomic) NSInteger lovenum;
@property(nonatomic) NSInteger p_time;
@property(nonatomic) NSInteger status;
@property(nonatomic) NSInteger tags_id;
@property(nonatomic) NSInteger type;
@property(nonatomic) NSInteger uid;
@property(nonatomic) NSInteger view_nums;
@property(nonatomic,strong) NSString * head_img;
@property(nonatomic,strong) NSString * img;
@property(nonatomic,strong) NSString * img_info;
@property(nonatomic,strong) NSString * img_list;
@property(nonatomic,strong) NSString * link;
@property(nonatomic,strong) NSString * recommend_goods_ids;
@property(nonatomic,strong) NSString * sub_title;
@property(nonatomic,strong) NSString * title;

@end

