//
//  YuYueViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface YuYueViewController : BaseViewController
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@end
