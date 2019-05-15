//
//  YuYueViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#import "sys/utsname.h"
#import "YuYueViewController.h"
#import "WGS84TOGCJ02.h"
#import "putInUserInfoViewController.h"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface YuYueViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate,CLLocationManagerDelegate>

@end

@implementation YuYueViewController
{
    UITextField *AddressText;
    BaseDomain *postData;
    BaseDomain *getData;
    UIButton *successButton;
    NSInteger clickNum;
    NSInteger yuYueStatus;
    NSString *time;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"预约量体"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"预约量体"];
    self.mapView.showsUserLocation =NO;
    self.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    clickNum = 0;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"预约量体"];
    WCLLog(@"%@",[SelfPersonInfo shareInstance].userModel);
    if ([[SelfPersonInfo shareInstance].userModel.is_yuyue integerValue] == 1) {
        [self.view setBackgroundColor:getUIColor(Color_background)];
//        [self getYuYueData];
        [self getYuYueData];
    } else {
        
        [self initMapView];
        [self configLocationManager];
        [self locateAction];
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
//        [view setBackgroundColor:[UIColor whiteColor]];
//        [self.view addSubview:view];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight-1, SCREEN_WIDTH, 1)];
        [line setBackgroundColor:getUIColor(Color_background)];
        [self.view addSubview:line];
    }
    
    
   
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
    
    [self.locationManager startUpdatingLocation];
}




- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}



- (void)locateAction
{
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位信息
        NSLog(@"location:%@", location);
        
        //逆地理信息
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
}
- (void)initMapView
{
    
    
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = 1;
        
        MACoordinateSpan span = MACoordinateSpanMake(0.004913, 0.013695);
        MACoordinateRegion region = MACoordinateRegionMake(_mapView.centerCoordinate, span);
        _mapView.region = region;
        
        [self.view addSubview:self.mapView];
        
    }
    
    AddressText = [[UITextField alloc] initWithFrame:CGRectMake(20, NavHeight+51, self.view.frame.size.width - 40, 50)];
    [AddressText.layer setCornerRadius:5];
    [AddressText.layer setMasksToBounds:YES];
    [AddressText.layer setBorderWidth:1];
    [AddressText.layer setBorderColor:[UIColor grayColor].CGColor];
    [AddressText setBackgroundColor:[UIColor whiteColor]];
    [AddressText setFont:[UIFont systemFontOfSize:12]];
    [AddressText setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:AddressText];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    image.center = _mapView.center;
    [image setImage:[UIImage imageNamed:@"BigHead"]];
    [self.view addSubview:image];
    
    
    UIButton *BtnYuYue = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 / 2,[ShiPeiIphoneXSRMax isIPhoneX]?self.view.frame.size.height-64-84: self.view.frame.size.height -64-50, self.view.frame.size.width / 2, 40)];
    [BtnYuYue setBackgroundColor:[UIColor blackColor]];
    [BtnYuYue.layer setCornerRadius:1];
    [BtnYuYue.layer setMasksToBounds:YES];
    [BtnYuYue addTarget:self action:@selector(clickYuYue) forControlEvents:UIControlEventTouchUpInside];
    [BtnYuYue setTitle:@"立即预约" forState:UIControlStateNormal];
    [self.view addSubview:BtnYuYue];
    
}

-(void)clickYuYue
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:AddressText.text forKey:@"address"];
   [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_YuYuelt_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            yuYueStatus = 1;
            [MobClick endEvent:@"measure" label:[SelfPersonInfo shareInstance].userModel.username];
            [self createHadYuYueView];
        }
        
    }];
}

-(void)getYuYueData
{
    [[wclNetTool sharedTools]request:POST urlString:URL_GetYuYueStatus parameters:@{}.mutableCopy finished:^(id responseObject, NSError *error) {
        yuYueStatus = [responseObject[@"data"][@"status"] integerValue];
        [self createHadYuYueView];
    }];
}

-(void)createHadYuYueView
{
    UIButton *imagev = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75 / 2, self.view.frame.size.height / 2 - 100, 75, 75)];
    [imagev setImage:[UIImage imageNamed:@"yuyuesuccess"] forState:UIControlStateNormal];
    [self.view addSubview:imagev];
   // [imagev addTarget:self action:@selector(FiveClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *success = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, 60)];
    
    [success setFont:[UIFont systemFontOfSize:14]];
    [success setTextAlignment:NSTextAlignmentCenter];
    [success setNumberOfLines:0];
    [self.view addSubview:success];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    [SelfPersonInfo shareInstance].userModel.is_yuyue = @"1";
    
    switch (yuYueStatus) {
        case 1:
        case 2:
            [success setText:@"当前状态：预约成功，等待客服受理"];
            break;
        case 3:
        case 4:
        {
            if([time intValue]==0)
            {
                success.text = @"当前状态：派单成功，等待上门量体";
            }
            else
            {
            [success setText:[NSString stringWithFormat:@"当前状态：派单成功，等待上门量体\n上门时间：%@",[self dateToString:time]]];
            }
        }
            break;
        case -1:
            success.text = @"当前状态：已取消";
            break;
        default:
            break;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:success.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [success.text length])];
    success.attributedText = attributedString;
    [success setFont:[UIFont systemFontOfSize:14]];
    [success setTextAlignment:NSTextAlignmentCenter];
    [success setNumberOfLines:2];
    successButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 70, SCREEN_HEIGHT - 100, 140, 35)];
    [successButton setBackgroundColor:getUIColor(Color_buyColor)];
    [successButton setTitle:@"拍照量体" forState:UIControlStateNormal];
   // [successButton addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
    [successButton.layer setCornerRadius:1];
    
    [successButton.layer setMasksToBounds:YES];
    [successButton setAlpha:0];
    [successButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:successButton];
    [self settabTitle:@"预约结果"];
}

-(NSString *)dateToString:(NSString *)dateString
{
    
    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}


-(void)FiveClick
{
    clickNum ++;
    if (clickNum == 5) {
        [ UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [successButton setAlpha:1];
        [UIView commitAnimations];
    }
}


//-(void)cameraClick {
//
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        putInUserInfoViewController *put = [[putInUserInfoViewController alloc] init];
//        [self.navigationController pushViewController:put animated:YES];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的机型暂时不支持该拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//
//}
//




- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    MACoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    
    [self getAddress:centerCoordinate.latitude longitude:centerCoordinate.longitude];
}


- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[location coordinate]];
        
        [self getAddress:coord.latitude longitude:coord.longitude];
    }
}

-(void)getAddress :(CLLocationDegrees)latitude
         longitude:(CLLocationDegrees)longitude
{
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic stringForKey:@"State"];
            NSString *city=[addressDic stringForKey:@"City"];
            NSString *subLocality=[addressDic stringForKey:@"SubLocality"];
            
            NSString *Thoroughfare = [addressDic stringForKey:@"Thoroughfare"];
            
            [AddressText setText:[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,Thoroughfare]];
            
        }  
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
