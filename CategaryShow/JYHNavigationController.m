//
//  JYHNavigationController.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "JYHNavigationController.h"
#import "JYHColor.h"

@interface JYHNavigationController ()

@end

@implementation JYHNavigationController
{
    BaseDomain *getIcon;
    NSArray *iconArray;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    getIcon = [BaseDomain getInstance:NO];
    iconArray = [NSArray array];
   
  

        
        // 禁用右滑切换
        self.interactivePopGestureRecognizer.enabled = NO;
        // 设置Bar背景色
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    
        [self.navigationBar setTintColor:[UIColor blackColor]];
        
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"Rectangle1"] forBarMetrics:UIBarMetricsDefault];//navi
        // 设置Bar不透明
//        [self.navigationBar setTranslucent:YES];

        [self.navigationBar setShadowImage:[UIImage new]];
    
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor]];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (MMDrawerController *) getMainFrameControllerClass {
//    UIViewController *parentViewController = self.parentViewController;
//    while (parentViewController != nil) {
//        if([parentViewController isKindOfClass:[MMDrawerController class]]){
//            return (MMDrawerController *)parentViewController;
//        }
//        parentViewController = parentViewController.parentViewController;
//    }
//    return nil;
//}

//- (UINavigationItem *)navigationItem{
//    UINavigationItem * item = [super navigationItem];
//
//    item.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    return item;
//}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//
//    self.navigationItem.backBarButtonItem = item;
    if (self.viewControllers.count > 0) {

        viewController.hidesBottomBarWhenPushed = YES;
        CATransition *animation = [CATransition animation];
        animation.duration = 0.4f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionReveal;
        animation.subtype = kCATransitionFromRight;
        [self.view.layer addAnimation:animation forKey:nil];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        
        negativeSpacer.width = -15;
       UIBarButtonItem* barbtnitem= [self backItemWithimage:[UIImage imageNamed:@"backLeftWhite"] highImage:[UIImage imageNamed:@"backLeftWhite"]  target:self action:@selector(back) title:@"返            回"];
        viewController.navigationItem.leftBarButtonItem = barbtnitem;
        [super pushViewController:viewController animated:NO];
        return;
    }
    [super pushViewController:viewController animated:YES];
    // 修改tabBra的frame
//    CGRect frame = self.tabBarController.tabBar.frame;
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//    self.tabBarController.tabBar.frame = frame;
}
- (void)back{
    [self popViewControllerAnimated:YES];
}
-(UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];//colorWithHexString:@"#FFFFFF"
    [backButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
//- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    [[self getMainFrameControllerClass] setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
//
//    [super pushViewController:viewController animated:animated];
//}
//
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//
//
////    if([self.parentViewController isKindOfClass:[MMDrawerController class]]){
////        [[self getMainFrameControllerClass] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
////    }
//    
//    return [super popViewControllerAnimated:animated];
//}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    if(self.mm_drawerController.showsStatusBarBackgroundView){
//        return UIStatusBarStyleLightContent;
//    }
//    else {
//        return UIStatusBarStyleDefault;
//    }
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
