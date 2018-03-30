//
//  designerModel.h
//  CategaryShow
//
//  Created by APPLE on 16/8/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface designerModel : NSObject
@property(nonatomic) NSInteger deginerID;
@property (nonatomic, retain) NSString *name;
@property(nonatomic)NSInteger des_uid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic) NSInteger c_time;
@property (nonatomic, retain) NSString *recommend_goods_ids;
@property (nonatomic, retain) NSString *goods_id;
@property (nonatomic, retain) NSString *img;
@property(nonatomic,strong)NSString *detailClothesImg;
@property (nonatomic, retain) NSString *p_time;
@property(nonatomic,strong)NSString *img_info;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *uname;
@property (nonatomic, retain) NSString *tag;
@property (nonatomic, retain) NSString *introduce;
@property(nonatomic,strong)NSString * c_time_format;
@property(nonatomic)NSInteger is_love;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger love_num;
@property(nonatomic)NSInteger commentnum;
@end
