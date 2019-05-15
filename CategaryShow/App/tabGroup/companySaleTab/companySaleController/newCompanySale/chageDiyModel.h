//
//  chageDiyModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/26.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chageDiyModel : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *content;
@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,strong)NSString * ad_img_info;
@property(nonatomic,strong)NSString * ad_img;
@property(nonatomic,strong)NSString * sell_price;
@property(nonatomic,assign)NSInteger is_new;
@end
