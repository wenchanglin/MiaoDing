//
//  MessageCount.h
//  QQ好友列表
//
//  Created by zhiyuan5958 on 15/2/27.
//  Copyright (c) 2015年 zhiyuan5958. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCount : NSObject


@property (nonatomic,assign) int notifationCount;//收到消息通知数量
@property (nonatomic,assign) BOOL backOrFore;//记录程序是否进入后台

+ (instancetype)getNotifationCount;

@end
