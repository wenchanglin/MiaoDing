//
//  LiangTiModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/4/24.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiangTiModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,assign) NSInteger height;
@property(nonatomic,assign)NSInteger weight;
@property(nonatomic,strong)NSString * img_list;
@property(nonatomic,assign)NSInteger is_index;
@end
