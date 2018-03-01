//
//  YSFDemoConfig.m
//  YSFDemo
//
//  Created by amao on 9/1/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "QYDemoConfig.h"
#import "QYSDK.h"

@interface QYDemoConfig ()
@end

@implementation QYDemoConfig
+ (instancetype)sharedConfig
{
    static QYDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QYDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _appKey     = @"e98a79aca99f25ebf9bacbc8c334b76b";
        _appName    = @"云工场";
        
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        if ([bundleId isEqualToString:@"com.mengwei.CloudFactory"])
        {
            _appName = @"云工场";
        }
    }
    return self;
}


- (void)setEnvironment:(BOOL)fromConfig
{
    if (fromConfig)
    {
        [[QYSDK sharedSDK] performSelector:@selector(readEnvironmentConfig)];
    }
}

@end

