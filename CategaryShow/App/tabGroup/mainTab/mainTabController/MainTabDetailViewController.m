//
//  MainTabDetailViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/12.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MainTabDetailViewController.h"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "designerModel.h"
#import "DesignersClothesViewController.h"
#import "BuyDesignerClothesViewController.h"
#import "DiyClothesDetailViewController.h"
@interface MainTabDetailViewController ()<UIWebViewDelegate>

@end

@implementation MainTabDetailViewController
{
    UIWebView *web;
    NSDate *datBegin;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self getDateBegin:datBegin currentView:@"首页" fatherView:_titleName];
}

-(void)viewWillAppear:(BOOL)animated
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:_titleName];
    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [buttonLeft setImage:[UIImage imageNamed:@"backLeftWhite"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    [buttonLeft setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];//colorWithHexString:@"#FFFFFF"
    [buttonLeft setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [buttonLeft sizeToFit];
    [buttonLeft setTitle:@"返            回" forState:UIControlStateNormal];
    buttonLeft.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    buttonLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [buttonLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:@"loginSuccess" object:nil];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];

    [self createScrollerView];
}

- (void)back:(UIBarButtonItem *)btn
{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        web.delegate = nil;
        [web removeFromSuperview];
        web = nil;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createScrollerView
{

//
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64 - NavHeight)];
    [self.view addSubview:web];
    [web setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];

    web.scrollView.scrollsToTop = YES;
    
    UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    
    NSURLRequest *request;
    web.delegate = self;
    if ([[userd stringForKey:@"token"] length] > 0) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&token=%@&content=1&ios=true&new_ios=1",URL_HeadForH5, URLZIXUAN, _webId, [userd stringForKey:@"token"]]]];
    } else {
         request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&content=1&ios=true&new_ios=1",URL_HeadForH5, URLZIXUAN, _webId]]];
    }
    
    
    [web loadRequest:request];
    
}

-(void)shareClick
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _imageUrl]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:_titleContent
                                      images:imageArray
                                         url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&type=1&ios=true",URL_HeadForH5, URLShare, _webId]]
                                       title:_titleName
                                        type:SSDKContentTypeWebPage];
    [ShareCustom shareWithContent:shareParams];
    
}



-(void)loginSuccessAction
{

    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSURLRequest *request;
    if ([[userd stringForKey:@"token"] length] > 0) {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&token=%@&content=1&ios=true&new_ios=1",URL_HeadForH5, URLZIXUAN, _webId, [userd stringForKey:@"token"]]]];
    } else {
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&content=1&ios=true&new_ios=1",URL_HeadForH5, URLZIXUAN, _webId]]];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
   
    if ([[[request URL] scheme] isEqualToString:@"onlogin"]) {
       
        if ([[[request URL] resourceSpecifier] isEqualToString:@"//tocommend"]) {
            if ([self userHaveLogin]) {
                return 0;
            }
            else
            {
            [self getDateBeginHaveReturn:datBegin fatherView:@"评论"];
            }
            
        } else {
            [self getDateBeginHaveReturn:datBegin fatherView:@"收藏"];
            
        }
        
    } else if ([[[request URL] scheme] isEqualToString:@"sale"]) {
        NSString *webData = [[[request URL] resourceSpecifier] stringByReplacingOccurrencesOfString:@"//" withString:@""];
        NSArray *arrayWeb = [webData componentsSeparatedByString:@";"];
        
        if ([arrayWeb[2] integerValue] == 1) {
            DiyClothesDetailViewController *toBuy = [[DiyClothesDetailViewController alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:arrayWeb[0] forKey:@"id"];
            [dic setObject:arrayWeb[1] forKey:@"thumb"];
            toBuy.goodDic = dic;
            [self.navigationController pushViewController:toBuy animated:YES];
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
