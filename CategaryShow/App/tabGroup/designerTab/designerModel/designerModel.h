//
//  designerModel.h
//  CategaryShow
//
//  Created by APPLE on 16/8/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface designerModel : NSObject
@property(nonatomic,assign) NSInteger ID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property(nonatomic,strong)NSString *ad_img;
@property(nonatomic,strong)NSString *ad_img_info;
@property (nonatomic, retain) NSString *sell_price;
@property(nonatomic)NSInteger is_love;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger love_num;
@end
