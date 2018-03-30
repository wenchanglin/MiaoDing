//
//  MySaveForZiXunModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/16.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySaveForZiXunModel : NSObject
@property(nonatomic) NSInteger c_time;
@property(nonatomic) NSInteger cid;
@property(nonatomic) NSInteger ID;
@property(nonatomic) NSInteger status;
@property(nonatomic) NSInteger type;
@property(nonatomic) NSInteger uid;
@property(nonatomic,strong) NSString * img;
@property(nonatomic,strong) NSString * img_info;
@property(nonatomic,strong)NSString * link;
@property(nonatomic,strong)NSString * sub_title;
@property(nonatomic,strong)NSString * title;

@end
