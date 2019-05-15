//
//  SelfpersonInfo.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/22.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userInfoModel.h"

#define PersonHistoryKey  @"userHistoryDataKey"

@interface SelfPersonInfo : NSObject
+(instancetype)shareInstance;
@property (nonatomic, assign) BOOL             isLoginStatus;
@property (nonatomic, strong) userInfoModel     *userModel;
-(void) exitLogin;
@end


