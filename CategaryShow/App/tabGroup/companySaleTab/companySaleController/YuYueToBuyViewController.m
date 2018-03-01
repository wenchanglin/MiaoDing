//
//  YuYueToBuyViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/21.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "YuYueToBuyViewController.h"
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface YuYueToBuyViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>

@end

@implementation YuYueToBuyViewController
{
    UITextField *AddressText;
    BaseDomain *getData;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约量体";
    getData = [BaseDomain getInstance:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:@"loginSuccess" object:nil];
    
    [self initMapView];
    [self configLocationManager];
    [self locateAction];

    
    // Do any additional setup after loading the view.
}

-(void)loginSuccessAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
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
    
    AddressText = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3 / 2, 84, self.view.frame.size.width / 3 * 2, 50)];
    [AddressText.layer setCornerRadius:5];
    [AddressText.layer setMasksToBounds:YES];
    [AddressText.layer setBorderWidth:1];
    [AddressText.layer setBorderColor:[UIColor blackColor].CGColor];
    [AddressText setBackgroundColor:[UIColor whiteColor]];
    [AddressText setFont:[UIFont systemFontOfSize:12]];
    [AddressText setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:AddressText];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    image.center = _mapView.center;
    [image setImage:[UIImage imageNamed:@"BigHead"]];
    [self.view addSubview:image];
    
    
    UIButton *BtnYuYue = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 / 2, self.view.frame.size.height - 100, self.view.frame.size.width / 2, 40)];
    [BtnYuYue setBackgroundColor:[UIColor blackColor]];
    [BtnYuYue.layer setCornerRadius:1];
    [BtnYuYue.layer setMasksToBounds:YES];
    [BtnYuYue addTarget:self action:@selector(clickYuYue:) forControlEvents:UIControlEventTouchUpInside];
    [BtnYuYue setTitle:@"立即预约" forState:UIControlStateNormal];
    [self.view addSubview:BtnYuYue];
    
}

-(void)clickYuYue:(UIButton *)sender
{
    
    [sender removeFromSuperview];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:AddressText.text forKey:@"address"];
    
    [getData postData:URL_YuYue PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            
            [self createHadYuYueView];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YYSuccess" object:nil];
            
//            NSArray *buttons = [NSArray arrayWithObjects:@"返回",@"调整细节", nil];
//            
//            
//            STAlertView *alert = [[STAlertView alloc] initWithTitle:@"提示"image:[UIImage imageNamed:@""] message:@"您已经预约成功，您想继续调整细节吗？"buttonTitles:buttons];
//            
//            alert.hideWhenTapOutside = YES;
//            [alert setDidShowHandler:^{
//                NSLog(@"显示了");
//            }];
//            [alert setDidHideHandler:^{
//                NSLog(@"消失了");
//            }];
//            [alert setActionHandler:^(NSInteger index) {
//                switch (index) {
//                    case 0:
//                    {
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                        break;
//                    case 1:
//                    {
//                        [self.navigationController popViewControllerAnimated:YES];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"YYSuccess" object:nil];
//                    }
//                        break;
//                    default:
//                        break;
//                }
//            }];
//            [alert show:YES];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经预约成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
            [alert show];
            
            
        }
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popToRootViewControllerAnimated:YES];

            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YYSuccess" object:nil];
        default:
            break;
    }
}

-(void)createHadYuYueView
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 75 / 2, self.view.frame.size.height / 2 - 75 / 2 - 40, 75, 75)];
    [imagev setImage:[UIImage imageNamed:@"yuyuesuccess"]];
    [self.view addSubview:imagev];
    
    UILabel *success = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, 30)];
    [success setText:@"您已经预约成功"];
    [success setFont:[UIFont systemFontOfSize:14]];
    [success setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:success];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    [SelfPersonInfo getInstance].personYuYue = @"1";
    self.title = @"预约结果";
}



- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    MACoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    
    [self getAddress:centerCoordinate.latitude longitude:centerCoordinate.longitude];
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
