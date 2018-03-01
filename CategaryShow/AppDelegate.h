    //
//  AppDelegate.h
//  TakeAuto
//
//  Created by 黄 梦炜 on 15/6/29.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


+ (instancetype) getInstance;

- (void) runMainViewController : (UIViewController *) childViewController;

- (void) runLoginViewController : (UIViewController *) childViewController;
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;

@property (nonatomic,strong) UIViewController * mainViewController;

@end

