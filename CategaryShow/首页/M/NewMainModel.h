//
//  NewMainModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewMainModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, assign) NSInteger like_nums;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * sub_title;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger reply_nums;
@property (nonatomic, assign) NSInteger view_nums;
@property(nonatomic,strong)  NSString * img_info;
@property(nonatomic,assign)NSInteger  is_love;
@property(nonatomic,assign)NSInteger is_collect;
@end
