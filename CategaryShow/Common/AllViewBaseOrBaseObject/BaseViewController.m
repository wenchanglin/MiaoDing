//
//  HHBaseViewController.m
//  DalianPort
//
//  Created by mac on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "EnterViewController.h"
#import "NewLoginViewController.h"
#import "JYHNavigationController.h"
#import "RDVTabBarController.h"
#import "UrlManager.h"
#import "sys/utsname.h"
#import "AppDelegate.h"
#import "LoginManager.h"
#import "Masonry.h"
#import "MCListViewController.h"
#import "MainTabBanerDetailViewController.h"
#import "mcWuLiuViewController.h"
#import "MainTabDetailViewController.h"
#import "DesignersClothesViewController.h"
#import "DesignerDetailIntroduce.h"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"

static NSString * Key_MsgList_Histroy_SearchTime = @"Message_SearchTime";

@interface BaseViewController ()
{
    CGFloat initViewY;
    Boolean isViewYFisrt;
    UIAlertView * alert;
    UIAlertView *alertTime;
    BaseDomain *timePostData;
    NSTimer *timers;
}

@property (nonatomic, retain) MBProgressHUD *progressHud;
@property (nonatomic, strong) XHBottomToolBar *bottomToolBar;
@property (nonatomic, retain) UIAlertView *Albumalert;

@property (nonatomic, retain) BaseDomain *details;

@property (nonatomic, retain) UILabel *messageWorning;
@property (nonatomic, retain) NSMutableArray *msgList;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) XHImageViewer* imageViewer;
@property (nonatomic, retain) NSMutableArray *imageViews;
@property (nonatomic, retain) UIAlertView *outAlert;
- (void)onSpaceViewClickToCloseKeyboard:(id)sender;
- (CGFloat) getControlFrameOriginY : (UIView *) curView;

@end

@implementation BaseViewController

{
    //    AwAlertView *awAlert;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isViewYFisrt = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewRootBak = self.view;
    self.details = [BaseDomain getInstance:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIControl * controlView = [[UIControl alloc] initWithFrame:self.view.frame];
    controlView.backgroundColor= [UIColor colorWithHexString:@"#EDEDED"];
    timePostData = [BaseDomain getInstance:NO];
    [controlView addTarget:self action:@selector(onSpaceViewClickToCloseKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    [self.view sendSubviewToBack:controlView];
    if (self.navigationItem != nil){
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNoti:) name:@"GeTui" object:nil];
    
    
    
}

- (void)onSpaceViewClickToCloseKeyboard:(id)sender{
    if (self.view != nil) {
        [self.view endEditing:YES];
    }
}


-(void)messageNoti:(NSNotification *)noti
{
    NSDictionary *message = [self dictionaryWithJsonString:[noti.userInfo stringForKey:@"message"]];
    switch ([message integerForKey:@"type"]) {
        case 1:
        {
            MCListViewController *MCList = [[MCListViewController alloc] init];
            MCList.mc_Id = [message stringForKey:@"type"];
            [self.navigationController pushViewController:MCList animated:NO];
        }
            break;
        case 2:
            
        {
            MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
            
            mainBaner.titleContent = [message stringForKey:@"title"];
            mainBaner.imageUrl = [message stringForKey:@"img_url"];
            mainBaner.webLink = [message stringForKey:@"link"];
            mainBaner.shareLink = [message stringForKey:@"share_link"];
            [self.navigationController pushViewController:mainBaner animated:YES];
        }
            
            break;
        case 3:
        {
            mcWuLiuViewController *list = [[mcWuLiuViewController alloc] init];
            list.mc_Id = [message stringForKey:@"type"];
            [self.navigationController pushViewController:list animated:YES];
            
        }
            break;
        case 4:
        {
            MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
            MainDetail.webId = [message stringForKey:@"id"];
            MainDetail.imageUrl = [message stringForKey:@"img_url"];
            MainDetail.titleContent = [message stringForKey:@"title"];
            [self.navigationController pushViewController:MainDetail animated:YES];
        }
            break;
        case 5:
        {
            DesignersClothesViewController *designerClothes = [[DesignersClothesViewController alloc] init];
            designerClothes.imageUrl = [message stringForKey:@"img_url"];
            designerClothes.good_Id = [message stringForKey:@"id"];
            designerClothes.clothesTitle = [message stringForKey:@"title"];
            designerClothes.clothesContent = [message stringForKey:@"content"];
            [self.navigationController pushViewController:designerClothes animated:YES];
        }
            break;
        case 6:
        {
            DesignerDetailIntroduce *introduce = [[DesignerDetailIntroduce alloc] init];
            introduce.desginerId = [message stringForKey:@"id"];
            introduce.designerImage = [message stringForKey:@"img_url"];
            introduce.designerName = [message stringForKey:@"title"];
            introduce.remark = [message stringForKey:@"content"];
            [self.navigationController pushViewController:introduce animated:YES];
            
        }
            
            
            break;
        case 7:
        {
            ToBuyCompanyClothes_SecondPlan_ViewController *toBuy = [[ToBuyCompanyClothes_SecondPlan_ViewController alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[message stringForKey:@"id"] forKey:@"id"];
            [dic setObject:[message stringForKey:@"title"] forKey:@"name"];
            [dic setObject:[message stringForKey:@"img_url"] forKey:@"thumb"];
            [dic setObject:[message stringForKey:@"type"] forKey:@"type"];
            toBuy.goodDic = dic;
            [self.navigationController pushViewController:toBuy animated:YES];
        }
            break;
        default:
            break;
    }
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

-(Boolean)userHaveLogin
{
      if ([SelfPersonInfo shareInstance].isLoginStatus) {
        return YES;
    } else return NO;
    
}



-(void)settabTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = Font_16;
    [titleLabel setTextColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    self.navigationItem.titleView = titleLabel;
}

-(void)settabImg:(NSString *)Img
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 23)];
    [image setImage:[UIImage imageNamed:Img]];
    self.rdv_tabBarController.navigationItem.titleView = image;
}




- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)progressShow:(NSString*) title animated:(BOOL)animated{
    
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.progressHud];
    
    UIImage *image = [[UIImage imageNamed:@"toast_loading"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    _progressHud.customView = imgView;
    //    self.progressHud.dimBackground = YES;
    //self.progressHud.delegate = self;
    
    if (title==nil) {
        title = @"请求中";
    }
    _progressHud.label.text = title;
    [self.progressHud show:YES];
}

- (void)progressHide:(BOOL)animated{
    
    if (self.progressHud != nil){
        [self.progressHud hide:animated];
        
        [self.progressHud removeFromSuperview];
        //[self.progressHud release];
        self.progressHud = nil;
        
    }
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (Boolean) checkHttpResponseResultStatus:(id) domain {
    
    if ([domain[@"code"]integerValue] == 10000) {
        return YES;
    } else if([domain[@"code"]integerValue] == 10001) {
        EnterViewController *enter = [[EnterViewController alloc] init];
        [self presentViewController:enter animated:YES completion:nil];
        return NO;
    }else if([domain[@"code"]integerValue] == 10005||[domain[@"code"]integerValue]==10007) {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:domain[@"msg"] delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_title_tip", nil) message:domain[@"msg"] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_okknow", nil) otherButtonTitles: nil];
        [alert show];
        return NO;
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (CGFloat) calculateTextHeight:(UIFont *)font givenText:(NSString *)text givenWidth:(CGFloat)width{
    CGFloat delta;
    if ([text isEqualToString:@""]) {
        delta = 0;
    } else {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        delta = size.height;
    }
    
    
    return delta;
    
}

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"6P";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"6SP";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"7P";
    if([deviceString isEqualToString:@"iPhone10,1"])    return @"8";
    if([deviceString isEqualToString:@"iPhone10,2"])    return @"8P";
    if([deviceString isEqualToString:@"iPhone10,3"])    return @"X";
    if([deviceString isEqualToString:@"iPhone10,4"])    return @"8";
    if([deviceString isEqualToString:@"iPhone10,5"])    return @"8P";
    if([deviceString isEqualToString:@"iPhone10,6"])    return @"X";
    
    return deviceString;
}


-(void )getDateBegin:(NSDate *)dateBegin currentView:(NSString *)view1 fatherView:(NSString *)view2
{
    NSDate* datfinish = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[datfinish timeIntervalSinceDate:dateBegin];
    NSInteger time = round(a);
    NSString *reTime = [NSString stringWithFormat:@"%ld", time];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:reTime forKey:@"time"];
    [params setObject:view1 forKey:@"module_name"];
    [params setObject:view2 forKey:@"p_module_name"];
    //    [timePostData postData:URL_USerActionMain PostParams:params finish:^(BaseDomain *domain, Boolean success) {
    //        if ([self checkHttpResponseResultStatus:timePostData]) {
    //            WCLLog(@"%@", domain.dataRoot);
    //        }
    //    }];
    
}

-(void )getDateBeginHaveReturn:(NSDate *)dateBegin fatherView:(NSString *)view2{
    EnterViewController *enter = [[EnterViewController alloc] init];
    [self presentViewController:enter animated:YES completion:nil];
}

-(void)getDateDingZhi:(NSMutableDictionary *)dic beginDate:(NSDate *)date ifDing:(BOOL)ding
{
    NSDate* datfinish = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[datfinish timeIntervalSinceDate:date];
    NSInteger time = round(a);
    NSString *reTime = [NSString stringWithFormat:@"%ld", time];
    
    if (ding) {
        [dic setObject:reTime forKey:@"dingzhi_time"];
    } else {
        [dic setObject:reTime forKey:@"goods_time"];
    }
    //    [timePostData postData:URL_UserDingAction PostParams:dic finish:^(BaseDomain *domain, Boolean success) {
    
    //        if ([self checkHttpResponseResultStatus:domain]) {
    //            NSLog( @"%@", domain.dataRoot);
    //        }
    
    //    }];
    
    
}


+ (NSString*) getFriendlyDateString : (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate ];
    
    NSDate *myDate = [NSDate date];
    
    NSString *DIF;
    NSString *strDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    NSDateComponents *compsCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compsNow = [calendar components:unitFlags fromDate:myDate];
    compsCur = [calendar components:unitFlags fromDate:curDate];
    
    if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]) {
        DIF=@"今天";
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
        
    }else if ([compsCur day]+1==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]){
        DIF=@"昨天";
        
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else{
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM-dd"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=dateStr;
    }
    
    return strDate;
    
}


-(void)hiddenALert
{
    if (timers.isValid) {
        [timers invalidate];
    }
    timers=nil;
    [alertTime dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)alertViewShowOfTime:(NSString *)message time:(NSInteger)time
{
    alertTime = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertTime show];
    timers= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(hiddenALert) userInfo:nil repeats:NO];
}

@end
