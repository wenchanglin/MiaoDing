//
//  IndexTypeModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/15.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexTypeModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,strong)NSString * img;
@property(nonatomic,assign)NSInteger is_type;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *img_info;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *sell_price;
@end
