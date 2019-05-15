//
//  WeiBoApiManager.h
//  百大悦城
//
//  Created by 文长林 on 2018/7/18.
//  Copyright © 2018年 文长林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@interface WeiBoApiManager : NSObject<WeiboSDKDelegate>
+ (instancetype)sharedManager;
@end
