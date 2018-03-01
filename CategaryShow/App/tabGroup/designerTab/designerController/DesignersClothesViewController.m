//
//  DesignersClothesViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/12.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#define URL_WEBURL @"http://www.cloudworkshop.cn/web/jquery-obj/static/web/html/detail.html"
//#define URL_CLOTHESDESIGNER @"html/detail.html"
#define URL_SHARE @"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/detail.html"
#define windowRect [UIScreen mainScreen].bounds
#import "DesignersClothesViewController.h"
#import "LYInputAccessoryView.h"
#import "BuyDesignerClothesViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>




#import "EnterViewController.h"
@interface DesignersClothesViewController ()<UITextFieldDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) LYInputAccessoryView *inputAccessoryView;
@end

@implementation DesignersClothesViewController
{
    UIImageView *bgImageView;
    UIWebView *web;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作品详情";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rloadWeb) name:@"loginSuccess" object:nil];
    
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    [self createViewFordesignersClothes];
    [self createScroller];
//    [self createLowView];
}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _imageUrl]]];
     [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:_clothesContent
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&type=2", URL_SHARE, _good_Id]]
                                      title:_clothesTitle
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];    
    
    
    
}



-(void)createScroller
{
    

    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [web sizeToFit];
    UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    NSURLRequest *request;
    if ([[userd stringForKey:@"token"] length] > 0) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&token=%@&type=2&ios=true", URL_WEBURL, _good_Id, [userd stringForKey:@"token"]]]];
    } else {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&type=2&ios=true", URL_WEBURL, _good_Id]]];
    }
    
    [web loadRequest:request];
    web.delegate = self;
    
    [self.view addSubview:web];
}

-(void)rloadWeb
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
 
    NSURLRequest *request;
    if ([[userd stringForKey:@"token"] length] > 0) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&token=%@&type=2&ios=true", URL_WEBURL, _good_Id, [userd stringForKey:@"token"]]]];
    } else {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&type=2&ios=true", URL_WEBURL, _good_Id]]];
    }
    
    [web loadRequest:request];
    
    

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([[[request URL] scheme] isEqualToString:@"myapp"]) {
        
        
        [self buyClick];
        return NO;
    } else if ([[[request URL] scheme] isEqualToString:@"onlogin"]) {
        EnterViewController *enter = [[EnterViewController alloc] init];
        [self presentViewController:enter animated:YES completion:nil];
    }
    
    return YES;
}

//-(void)createLowView
//{
//    self.textField = [UITextField new];
//    [_textField setDelegate:self];
//    [self.view addSubview:self.textField];
//    UIButton *button = [UIButton new];
//    [self.view addSubview:button];
//    
//    button.sd_layout
//    .rightSpaceToView(self.view, 10)
//    .bottomSpaceToView(self.view, 55)
//    .heightIs(47 / 2)
//    .widthIs(50 / 2 );
//    [button setBackgroundImage:[UIImage imageNamed:@"likeClick"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(addMySave) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIButton *buttonPin = [UIButton new];
//    [self.view addSubview:buttonPin];
//    
//    buttonPin.sd_layout
//    .rightSpaceToView(button, 10)
//    .bottomSpaceToView(self.view, 55)
//    .heightIs(48 / 2)
//    .widthIs(54 / 2 );
//    [buttonPin setBackgroundImage:[UIImage imageNamed:@"pinLunClick"] forState:UIControlStateNormal];
//    [buttonPin addTarget:self action:@selector(pinlunClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    self.inputAccessoryView = [[LYInputAccessoryView alloc] initWithFrame: CGRectMake(0, 0, windowRect.size.width, 40)];
//   
//    self.textField.inputAccessoryView = self.inputAccessoryView;
//}





-(void)pinlunClick{
    [self.textField becomeFirstResponder];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)addMySave{
   
//    [self showAlertWithTitle:@"提示" message:@"加入收藏成功"];
    [self alertViewShowOfTime:@"加入收藏成功" time:1.5];

}

-(void)buyClick
{
    BuyDesignerClothesViewController *buyDesigner = [[BuyDesignerClothesViewController alloc] init];
    buyDesigner.good_Id = _good_Id;
    [self.navigationController pushViewController:buyDesigner animated:YES];
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
