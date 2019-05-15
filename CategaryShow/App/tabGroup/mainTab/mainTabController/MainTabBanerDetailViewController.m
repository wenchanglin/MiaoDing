//
//  MainTabBanerDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/6.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MainTabBanerDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "BuyDesignerClothesViewController.h"

#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface MainTabBanerDetailViewController ()<UIWebViewDelegate>

@end

@implementation MainTabBanerDetailViewController

{
    UIWebView *web;
    NSDate *datBegin;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:_titleContent];
    
    
    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [buttonLeft setImage:[UIImage imageNamed:@"backLeftWhite"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    [buttonLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [buttonLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:@"loginSuccess" object:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    [self createScrollerView];
}
    
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)back:(UIBarButtonItem *)btn
{
    if ([web canGoBack]) {
        [web goBack];
        
    }else{
        web.delegate = nil;
        [web removeFromSuperview];
        web = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _imageUrl]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:_titleContent
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&ios=true",URL_HEADURL,_shareLink]]
                                      title:_titleContent
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];    
    
    
    
}




-(void)createScrollerView
{
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:web];
    web.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    web.scrollView.scrollsToTop = YES;
    
    UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
   
    NSURLRequest *request;
    web.delegate = self;
    if ([[userd stringForKey:@"token"] length] > 0) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&token=%@&ios=true",URL_HEADURL,_webLink, [userd stringForKey:@"token"]]]];
    } else {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&ios=true", URL_HEADURL,_webLink]]];
    }
    
    
    
    [web loadRequest:request];
    
    
    
    
}

-(void)loginSuccessAction
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSURLRequest *request;
    if ([[userd stringForKey:@"token"] length] > 0) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&token=%@&ios=true",URL_HEADURL,_webLink, [userd stringForKey:@"token"]]]];
    } else {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&ios=true", URL_HEADURL,_webLink]]];
    }
    
    [web loadRequest:request];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if ([[[request URL] scheme] isEqualToString:@"onlogin"]) {
    
        if ([[[request URL] resourceSpecifier] isEqualToString:@"//tocommend"]) {
            [self getDateBeginHaveReturn:datBegin fatherView:@"评论"];

        } else {
            [self getDateBeginHaveReturn:datBegin fatherView:@"收藏"];

        }
        
    }else if ([[[request URL] scheme] isEqualToString:@"sale"]) {
        NSString *webData = [[[request URL] resourceSpecifier] stringByReplacingOccurrencesOfString:@"//" withString:@""];
        NSArray *arrayWeb = [webData componentsSeparatedByString:@";"];
        
        if ([arrayWeb[2] integerValue] == 1) {
            ToBuyCompanyClothes_SecondPlan_ViewController *tobuy = [[ToBuyCompanyClothes_SecondPlan_ViewController alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:arrayWeb[0] forKey:@"id"];
            [dic setObject:arrayWeb[1] forKey:@"thumb"];
            tobuy.goodDic = dic;
            [self.navigationController pushViewController:tobuy animated:YES];
        } else {
            
            BuyDesignerClothesViewController *buyDesigner = [[BuyDesignerClothesViewController alloc] init];
            buyDesigner.good_Id = arrayWeb[0];
            buyDesigner.imageURl = arrayWeb[1];
            [self.navigationController pushViewController:buyDesigner animated:YES];
           
            
        }
        
        
        
    }
    
    return YES;
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
