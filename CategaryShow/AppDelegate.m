//
//  AppDelegate.m
//  TakeAuto
//
//  Created by 黄 梦炜 on 15/6/29.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高
#import "SelfPersonInfo.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "EnterViewController.h"
#import "LoginManager.h"
#import "MainTabBarController.h"
#import "JYHNavigationController.h"
#import "JYHColor.h"
#import "JsonColumnsDefine.h"

#import "MessageCount.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WXApiManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <AlipaySDK/AlipaySDK.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APIKey.h"

#import <GTSDK/GeTuiSdk.h>    // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework

static AppDelegate * appDelegate;
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";


#define kGtAppId           @"giNqTlq7c4AAPv4gmSmKL8"
#define kGtAppKey          @"XbVdzpYsN771CK381mlfq4"
#define kGtAppSecret       @"48KWdZqTYU61sbKimhCb02"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UIAlertViewDelegate,RDVTabBarControllerDelegate,UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
@property (nonatomic, retain) NSString *payloadId;
@property (nonatomic, assign) int lastPayloadIndex;

@property (nonatomic, assign) SystemSoundID soundID;

@property (assign,nonatomic) Boolean threadIsRun;

@property (assign,nonatomic) Boolean threadIsPause;

@property (retain,nonatomic) NSThread *threadRefreshData;

@property (nonatomic, assign) BOOL Noti;
@end

@implementation AppDelegate
{
    BaseDomain *getDataIcon;
    
}
+ (instancetype) getInstance {
    return appDelegate;
}


- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
    
    
    
    
}


- (void) checkServerDataThread {
   
}

-(void)searchDetailsData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageReceive" object:nil];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"login" forKey:@"status"];
    
    getDataIcon = [BaseDomain getInstance:NO];
    
    self.threadIsPause = NO;
    self.Noti = NO;
    self.threadIsRun = YES;
//    self.threadRefreshData = [[NSThread alloc] initWithTarget:self selector:@selector(checkServerDataThread) object:nil];
//    [self.threadRefreshData start];
    appDelegate = self;
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    [self runMainViewController : nil];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字

    //[self checkAppUpdate];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//        // 这里判断是否第一次
//        hDisplayView *hvc = [[hDisplayView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height)];
//        [self.window.rootViewController.view addSubview:hvc];
//        [UIView animateWithDuration:0.25 animations:^{
//            hvc.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
//        }];
//    }
    
    
    [self configureAPIKey];
    [self registerShareSdk];

    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    
    [[QYSDK sharedSDK] registerAppId:@"e98a79aca99f25ebf9bacbc8c334b76b"
                             appName:@"云工场"];
    [WXApi registerApp:@"wx07c2173e7686741e" withDescription:@"demo 2.0"];
    
    getDataIcon = [BaseDomain getInstance:NO];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:@"2" forKey:@"type"];
    [getDataIcon getData:URL_getIcon PostParams:parmas finish:^(BaseDomain *domain, Boolean success) {
        
    }];
    
    return YES;
}
-(void)checkAppUpdate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString * URL = @"http://itunes.apple.com/lookup?id=1159191582";
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
        if (!data) {
            return ;
        }
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
       // NSLog(@"jsonDic%@",jsonDict);
        jsonDict = [jsonDict[@"results"] firstObject];
        
        if (!error && jsonDict) {
            NSString *newVersion =jsonDict[@"version"];
            NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            
            NSString *dot = @".";
            NSString *whiteSpace = @"";
            int newV = [newVersion stringByReplacingOccurrencesOfString:dot withString:whiteSpace].intValue;
            int nowV = [nowVersion stringByReplacingOccurrencesOfString:dot withString:whiteSpace].intValue;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(newV > nowV)
                {
                    NSString * title = @"版本更新";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:jsonDict[@"releaseNotes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
                    [alert show];
                    
                }
                
            });
        }
    });
}
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}





-(void)registerShareSdk
{
    [ShareSDK registerApp:@"188b0b9b49186"
          activePlatforms:@[
                
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  
                 
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx07c2173e7686741e"
                                            appSecret:@"bb8ae0571dd28e0ea9623b1c9e9424fd"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105803355"
                                           appKey:@"gAccBmTUz0l6yNti"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  
                  default:
                      break;
              }
          }];

    
    
}













-(void)systemShake
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(NSString*) formateTime:(NSDate*) date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    
    return dateTime;
}



- (void) runLoginThread: (NSObject *) argv {
    [[LoginManager getInstance] loginSystemAuth];
}

- (void) runMainViewController : (UIViewController *) childViewController{
    if (childViewController) {
        [childViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (self.mainViewController)
        [self.mainViewController removeFromParentViewController];
    
    MainTabBarController * viewController = [[MainTabBarController alloc] init];
    viewController.delegate = self;
    self.mainViewController = [[JYHNavigationController alloc] initWithRootViewController:viewController];
    
    //        self.drawerController = [[MainTabBarController alloc] init];
    
    [self.window setRootViewController:self.mainViewController];
    
    [self.window makeKeyAndVisible];
    
}

- (void) runLoginViewController : (UIViewController *) childViewController{
    
    if (childViewController) {
        [childViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (self.mainViewController)
        [self.mainViewController removeFromParentViewController];
    
    UIViewController * viewController = [[EnterViewController alloc] init];
    
    self.mainViewController = [[JYHNavigationController alloc] initWithRootViewController:viewController];
    
    [self.window setRootViewController:self.mainViewController];
    
    [self.window makeKeyAndVisible];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
    MessageCount *message = [MessageCount getNotifationCount];
    message.notifationCount = 0;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];

    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [userd setObject:clientId forKey:@"cId"];
    
    BaseDomain *getData = [BaseDomain getInstance:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:clientId forKey:@"device_id"];
    [params setObject:@"2" forKey:@"type"];
    
    [getData getData:URL_Message PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
    }];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    
    if (_Noti) {
        _Noti = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:payloadMsg forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GeTui" object:nil userInfo:dic];
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roadCound" object:nil];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo {
    
    
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    
    // [4-EXT]:处理APN
    
    
    
    if ([UIApplication sharedApplication].applicationState ==UIApplicationStateBackground ) {
        
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        _Noti = YES;
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/yun-gong-chang/id1159191582?l=zh&ls=1&mt=8"]];
    }
    
    
    
    
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic stringForKey:@"resultStatus"] integerValue] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccess" object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayFlase" object:nil];
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    } else if ([url.host isEqualToString:@"pay"]) {
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}





@end




