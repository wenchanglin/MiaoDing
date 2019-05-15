//
//  LoginIsAutoCheck.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//
#import "sys/utsname.h"

#import "LoginManager.h"
#import "UrlManager.h"
#import "SelfPersonInfo.h"
#import "AppDelegate.h"
#import "SCLAlertView.h"
#import "userInfoModel.h"

static LoginManager * _loginCheck;

@interface LoginManager()

@property (nonatomic, retain) userInfoModel *userInfo;

@end

@implementation LoginManager


+ (instancetype) getInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_loginCheck == nil) {
            _loginCheck = [[LoginManager alloc] init];
            [_loginCheck initUserDefalutsValue];
        }
    });
    
    return _loginCheck;
}


- (void) initUserDefalutsValue {
    self.userName = [[NSUserDefaults standardUserDefaults] stringForKey:Histroy_UserName];
    
    self.userPassword = [[NSUserDefaults standardUserDefaults] stringForKey:Histroy_Password];
    
    self.isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:Histroy_IsAutoLogin];
}

- (Boolean) checkAutoLogin {
    if (self.userName != nil && self.userPassword != nil && self.isAutoLogin)
        return YES;
    else
        return NO;
}

- (void) saveLoginData:(NSString *) userName userPwd:(NSString*) userPassword isAuto:(Boolean) isAutoLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userName forKey:Histroy_UserName];
    [userDefaults setObject:userPassword forKey:Histroy_Password];
    [userDefaults setBool:isAutoLogin forKey:Histroy_IsAutoLogin];
    
    [userDefaults synchronize];
    
    self.userName = userName;
    self.userPassword = userPassword;
    self.isAutoLogin = isAutoLogin;
}

- (Boolean) loginSystemAuth {
    
    __block Boolean resultValue = NO;
    
    __block Boolean postFinish = NO;
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [params setValue:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"imei"];
    
    [params setValue:self.userName forKey:@"account"];
    
    [params setValue:self.userPassword forKey:@"password"];
    
//    [self.loginDomain postData:URL_LoginAuth PostParams:params finish:^(BaseDomain * domain,Boolean success) {
//        if (self.loginDomain.result == 0) {
//
//
//            resultValue = YES;
//
//            postFinish = YES;
//        }
//        else {
//            resultValue = NO;
//
//            postFinish = YES;
//        }
//    }];
    
    while (!postFinish)
        [NSThread sleepForTimeInterval:0.1];
    
    return resultValue;
}
- (void) postLoginAuth:(NSString*) userName userPwd:(NSString*) userPassword loginId:(NSString *)loginId  isAuto:(Boolean) isAutoLogin finish:(void (^)(Boolean)) finish {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:userName forKey:@"user_phone"];
    [params setValue:userPassword forKey:@"sms"];
    [params setValue:loginId forKey:@"id"];
    [params setValue:@"2" forKey:@"phone_type"];
    [[wclNetTool sharedTools]request:POST urlString:URL_LoginAuth parameters:params finished:^(id responseObject, NSError *error) {
        WCLLog(@"root == %@", responseObject);
        if ([responseObject[@"code"]integerValue]==10000) {
             userInfoModel * infomodel = [userInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            [SelfPersonInfo shareInstance].userModel=infomodel;
            NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
            [used setObject:[responseObject[@"data"] stringForKey:@"token"] forKey:@"token"];
            if (finish) {
                finish(YES);
            }
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:responseObject[@"msg"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
            
            [alertView show];
            
            if (finish) {
                finish(NO);
            }
        }
    }];
    
}
- (void) postLoginAuth:(NSString*) userName userPwd:(NSString*) userPassword loginId:(NSString *)loginId userId:(NSString *)userid icon:(NSString *)icon nickName:(NSString*)nickname isType:(NSInteger)is_type isAuto:(Boolean) isAutoLogin finish:(void (^)(Boolean)) finish {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [params setValue:[userd stringForKey:@"token"] forKey:@"token"];
    [params setObject:@(is_type) forKey:@"is_type"];//do_login
    [params setObject:userid forKey:@"userid"];
    [params setObject:icon forKey:@"icon"];
    [params setObject:nickname forKey:@"nickname"];
    [params setValue:userName forKey:@"phone"];
    [params setValue:userPassword forKey:@"code"];
    [params setValue:loginId forKey:@"id"];
    [params setValue:[userd stringForKey:@"cId"] forKey:@"device_id"];
    [params setValue:@"2" forKey:@"phone_type"];
    [params setValue:[self deviceVersion] forKey:@"device_type"];
    
    WCLLog(@"%@", URL_LoginAuth);
//    [self.loginDomain postData:URL_LoginAuth PostParams:params finish:^(BaseDomain * domain,Boolean success) {
//        WCLLog(@"root == %@", domain.dataRoot);
//        
//        if (self.loginDomain.result == 1) {
//            NSUserDefaults *used = [NSUserDefaults standardUserDefaults];
//            [used setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"token"] forKey:@"token"];
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//            [user setObject:@"login" forKey:@"status"];
//            [self saveLoginData:userName userPwd:userPassword isAuto:isAutoLogin];
////            [self.userInfo saveLoginData:userName userImg:userPassword];
////            [[SelfPersonInfo shareInstance].userModel setPersonInfoFromJsonData:self.loginDomain.dataRoot];
////
////            [[userInfoModel getInstance] saveLoginData:userName userImg:@""];
//            
//            if (finish) {
//                finish(YES);
//            }
//        }
//        else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:self.loginDomain.resultMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
//            
//            [alertView show];
//            
//            if (finish) {
//                finish(NO);
//            }
//        }
//    }];
}

- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"6P";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"6SP";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"7P";
    if([deviceString isEqualToString:@"iPhone10,1"])    return @"8";
    if([deviceString isEqualToString:@"iPhone10,2"])    return @"8P";
    if([deviceString isEqualToString:@"iPhone10,3"])    return @"X";
    if([deviceString isEqualToString:@"iPhone10,4"])    return @"8";
    if([deviceString isEqualToString:@"iPhone10,5"])    return @"8P";
    if([deviceString isEqualToString:@"iPhone10,6"])    return @"X";
    
    
    return deviceString;
}

- (void) exitSystemLogin : (UIViewController *) viewController {
    
    SCLAlertView * alertView = [[SCLAlertView alloc] init];
    
    [alertView addButton:NSLocalizedString(@"dialog_button_ok", nil)  actionBlock:^{
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults removeObjectForKey:Histroy_IsAutoLogin];
        [userDefaults removeObjectForKey:Histroy_Password];
        
        [userDefaults synchronize];
        
        [self initUserDefalutsValue];
        
        [[AppDelegate getInstance] runLoginViewController:viewController];
    }];
    
    [alertView showInfo:NSLocalizedString(@"dialog_title_tip", nil) subTitle:NSLocalizedString(@"homemore_zhuxiao_tip", nil) closeButtonTitle:NSLocalizedString(@"dialog_button_cancel", nil) duration:0];
}


@end
