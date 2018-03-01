//
//  MessageCount.m
//  QQ好友列表
//
//  Created by zhiyuan5958 on 15/2/27.
//  Copyright (c) 2015年 zhiyuan5958. All rights reserved.
//

#import "MessageCount.h"

@implementation MessageCount

+ (instancetype)getNotifationCount
{
    static MessageCount * messageCount;
    if (!messageCount) {
        messageCount = [[MessageCount alloc]init];
    }
    return messageCount;
}



@end
