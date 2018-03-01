//
//  homeNewViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/20.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
@interface QYAppKeyConfig : NSObject<NSCoding>
@property (nonatomic,copy)      NSString    *appKey;
@property (nonatomic,assign)    BOOL        useDevEnvironment;
@end
@interface homeNewViewController : BaseViewController

@end
