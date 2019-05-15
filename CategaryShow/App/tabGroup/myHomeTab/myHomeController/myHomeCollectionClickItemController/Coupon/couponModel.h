//
//  couponModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface couponModel : NSObject
@property(nonatomic,strong)NSString*cart_id_s;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString* full_money;
@property (nonatomic, retain) NSString *money;
@property(nonatomic,strong)NSString*e_time;
@property (nonatomic, retain) NSString *re_marks;
@property (nonatomic, retain) NSString *s_time;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *sub_title;
@property (nonatomic, retain) NSString *title;
@end
