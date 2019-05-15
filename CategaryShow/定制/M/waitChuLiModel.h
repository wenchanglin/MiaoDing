//
//  waitChuLiModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/17.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface waitChuLiModel : NSObject
@property(nonatomic,strong)NSString*order_sn;
@property(nonatomic,strong)NSString*order_amount;
@property(nonatomic,strong)NSString*payable_amount;
@property(nonatomic,strong)NSString*ticket_reduce_money;
@property(nonatomic,strong)NSString*discount;
@property(nonatomic,strong)NSString*promotions;
@property(nonatomic,strong)NSString*real_freight;
@end

NS_ASSUME_NONNULL_END
