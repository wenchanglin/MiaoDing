//
//  MyHomeViewControllerOtherBan.h
//  CategaryShow
//
//  Created by APPLE on 16/8/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
@interface QYAppKey : NSObject<NSCoding>
@property (nonatomic,copy)      NSString    *appKey;
@property (nonatomic,assign)    BOOL        useDevEnvironment;
@end
@interface MyHomeViewControllerOtherBan : BaseViewController

@end
