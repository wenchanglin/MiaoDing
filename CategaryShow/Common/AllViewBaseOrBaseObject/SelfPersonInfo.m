//
//  SelfPersonInfo.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/22.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "SelfPersonInfo.h"
#import "NSDictionary+EmptyString.h"
#import "JSONKit.h"
#import "BaseDomain.h"
static NSString *const kUserModel     = @"bdUserModel";
@implementation SelfPersonInfo

+ (instancetype)shareInstance {
    static SelfPersonInfo *selfPersonInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selfPersonInfo = [[SelfPersonInfo alloc] init];
    });
    return selfPersonInfo;
}
-(BOOL)isLoginStatus
{
    return self.userModel.username !=nil?YES:NO;
}
- (void)setUserModel:(userInfoModel *)userModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    [userDefaults setObject:data forKey:kUserModel];
    [userDefaults synchronize];
}
- (userInfoModel *)userModel{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserModel];
    userInfoModel * userModel = [userInfoModel mj_objectWithKeyValues:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    return userModel;
}
- (void)exitLogin
{
    [SelfPersonInfo shareInstance].userModel=nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserModel];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    
}
@end
