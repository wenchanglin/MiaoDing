//
//  ShiPeiIphoneXSRMax.m
//  CategaryShow
//
//  Created by 文长林 on 2018/9/19.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "ShiPeiIphoneXSRMax.h"

@implementation ShiPeiIphoneXSRMax
+(BOOL)isIPhoneX{
    BOOL iPhoneX = NO;
    /// 先判断设备是否是iPhone/iPod
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) {
        /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    
    return iPhoneX;
}
@end
