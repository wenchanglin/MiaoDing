//
//  YuYueToBuyViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/21.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface YuYueToBuyViewController : BaseViewController
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, retain) NSString *goodName;
@end
