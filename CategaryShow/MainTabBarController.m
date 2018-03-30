//
//  MainTabBarController.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/19.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//
#import "NewMainTabViewController.h"
#import "MainTabBarController.h"
#import "JYHColor.h"
#import "JYHTabBarItem.h"
#import "JYHNavigationController.h"
#import "RDVTabBarItem.h"
#import "designerViewController.h"
#import "CustomMainViewController.h"
#import "MyHomeViewController.h"
#import "MainTabViewController.h"
#import "MyHomeViewControllerOtherBan.h"
#import "QYDemoConfig.h"
#import "CompanySaleFirstViewController.h"

#import "newDesignerViewController.h"
#import "DesignerAlsoViewController.h"

#import "DesignerForCollectionViewController.h"
#import "NewMainParentViewController.h"
#import "homeNewViewController.h"
#import "DiyFirstViewController.h"
#import "DesignerAlsoViewController.h"
#import "changeDiyFirstViewController.h"
//#import "MyHomeViewControllerOtherBan.h"
@interface MainTabBarController ()

@property (retain,nonatomic) RDVTabBarItem * homeItem;

- (void) initTabBarDefaultStyle;

//- (IBAction)onHomeItemClick:(id)sender;

@end

@implementation MainTabBarController

@synthesize homeItem = _homeItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.navigationItem != nil){
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    UIImageView * mView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, IsiPhoneX?83:49)];//这是整个tabbar的颜色
    [mView setImage:[UIImage imageNamed:@"tabBackImage"]];
    [self.tabBar insertSubview:mView atIndex:1];
    
    

//    [[UITabBar appearance] setBackgroundColor:getUIColor(Color_tabbarbackcolor)];
    
//    [self.tabBar.backgroundView setBackgroundColor:getUIColor(Color_tabbarbackcolor)]; 
    
    [[RDVTabBarItem appearance] setSelectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil]];
    
    [[RDVTabBarItem appearance] setUnselectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:getUIColor(Color_tabbartextcolor), UITextAttributeTextColor,nil]];
    
    // Add TabItem
    [self initTabBarDefaultStyle];
    
    [self readAppkey];
    [self createQyUi];
}

- (void)readAppkey
{
    QYAppKeyConfig *config = [NSKeyedUnarchiver unarchiveObjectWithFile:[self configFilepath]];
    if (config)
    {
        [[QYDemoConfig sharedConfig] setAppKey:config.appKey];
        [[QYDemoConfig sharedConfig] setEnvironment:config.useDevEnvironment];
        NSString *appKey = [[QYDemoConfig sharedConfig] appKey];
        NSString *appName= [[QYDemoConfig sharedConfig] appName];
        [[QYSDK sharedSDK] registerAppId:appKey appName:appName];
    }
    else {
        NSString *appKey = [[QYDemoConfig sharedConfig] appKey];
        NSString *appName= [[QYDemoConfig sharedConfig] appName];
        [[QYSDK sharedSDK] registerAppId:appKey appName:appName];
    }
}

-(void)createQyUi
{
//    [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
//    /**
//     *  客服文本消息字体颜色
//     */
//    [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];
//    /**
//     *  消息tableview的背景图片
//     */
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg"]];
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
//    /**
//     *  访客头像
//     */
    [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"HeadImage"];
//    /**
//     *  客服头像
//     */
//    [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"service_head"];
//    /**
//     *  访客消息气泡normal图片
//     */
//    [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage =
//    [[UIImage imageNamed:@"icon_sender_node"]
//     resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
//     resizingMode:UIImageResizingModeStretch];
//    /**
//     *  访客消息气泡pressed图片
//     */
//    [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage =
//    [[UIImage imageNamed:@"icon_sender_node"]
//     resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
//     resizingMode:UIImageResizingModeStretch];
//    /**
//     *  客服消息气泡normal图片
//     */
//    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage =
//    [[UIImage imageNamed:@"icon_receiver_node"]
//     resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
//     resizingMode:UIImageResizingModeStretch];
//    /**
//     *  客服消息气泡pressed图片
//     */
//    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage =
//    [[UIImage imageNamed:@"icon_receiver_node"]
//     resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
//     resizingMode:UIImageResizingModeStretch];
//    /**
//     *  默认是YES,默认rightBarButtonItem内容是黑色，设置为NO，可以修改为白色
//     */
//    [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = YES;
//    /**
//     *  默认是YES,默认显示发送语音入口，设置为NO，可以修改为隐藏
//     */
//    [QYCustomUIConfig sharedInstance].showAudioEntry = YES;
//    /**
//     *  默认是YES,默认显示发送表情入口，设置为NO，可以修改为隐藏
//     */
//    [QYCustomUIConfig sharedInstance].showEmoticonEntry = YES;
//    /**
//     *  默认是YES,默认进入聊天界面，是文本输入模式的话，会弹出键盘，设置为NO，可以修改为不弹出
//     */
//    [QYCustomUIConfig sharedInstance].autoShowKeyboard = YES;
}


- (NSString *)configFilepath
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [dir stringByAppendingPathComponent:@"qy_appkey.plist"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBar layoutSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initTabBarDefaultStyle {
 
    UIViewController *main = [[NewMainTabViewController alloc] init];
    UIViewController * custom = [[changeDiyFirstViewController alloc] init];
    UIViewController *myHome = [[homeNewViewController alloc] init];
    UIViewController *desig = [[DesignerAlsoViewController alloc] init];//DesignerAndClothesViewController
    self.viewControllers = [[NSArray alloc] initWithObjects:main,custom,desig,myHome,nil];
    RDVTabBarItem *aTabBarItem = [self.tabBar.items objectAtIndex:0];
    // Set Title
    aTabBarItem.title = @"首页";;
    [aTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"首页选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"首页"]];
    
    RDVTabBarItem *bTabBarItem = [self.tabBar.items objectAtIndex:1];
    // Set Title
    bTabBarItem.title = @"定制";;
    [bTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"定制选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"定制"]];
    
    RDVTabBarItem *cTabBarItem = [self.tabBar.items objectAtIndex:2];
    // Set Title
    cTabBarItem.title = @"腔调";;
    [cTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"腔调选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"腔调"]];
    
    RDVTabBarItem *dTabBarItem = [self.tabBar.items objectAtIndex:3];
    // Set Title
    dTabBarItem.title = @"我的";;
    [dTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"我的选中"] withFinishedUnselectedImage:[UIImage imageNamed:@"我的"]];
    
    [aTabBarItem setSelectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor,nil]];
    
    [aTabBarItem setUnselectedTitleAttributes:[NSDictionary dictionaryWithObjectsAndKeys:getUIColor(Color_tabbartextcolor), UITextAttributeTextColor,nil]];
}


-(NSString *)writeToFile:(NSString *)namePng image:(UIImage *)img
{
    
    
    NSString *imgName = nil;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 得到本地沙盒中名为"MyImage"的路径，"namepng"是保存的图片名 如果要用二倍图就@2x，如果要用三倍图就@3x
    NSString *imageFilePath = [path stringByAppendingPathComponent:namePng];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    BOOL success = [UIImageJPEGRepresentation(img, 1) writeToFile:imageFilePath  atomically:YES];
    if (success) {
        imgName = imageFilePath;
    } else {
        imgName = nil;
    }
    
    return imgName;
    
    
}


- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

//- (void) setRigthButtonDefaultStyle {
//    
//    UIButton * buttonImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//    
//    [buttonImage setBackgroundImage:[UIImage imageNamed:@"navbarrightbutton"] forState:UIControlStateNormal];
//    [buttonImage setBackgroundImage:[UIImage imageNamed:@"navbarrightbutton_selected"] forState:UIControlStateHighlighted];
//    
//    [buttonImage addTarget:self action:@selector(viewMoreViewController:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonImage];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
