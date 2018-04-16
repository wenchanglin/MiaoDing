
//
//  inviteNewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#define URL_SHARE @"/web/jquery-obj/static/fx/html/yaoqing.html"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "inviteNewViewController.h"
#import "ruleViewController.h"
@interface inviteNewViewController ()

@end

@implementation inviteNewViewController
{
    UIImageView *inviteBackImg;
    UIImageView *EWMImg;
    BaseDomain *getData;
    NSMutableDictionary *inviteDic;
    NSString *uId;
    NSString *imgRul;
    NSString *imgShare;
    UIWebView *web;
}

-(void)shareClick
{
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].personImageUrl]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@邀请您一起做腔调绅士，来吧，用1000元见面礼定制一套体面的行头",[SelfPersonInfo getInstance].cnPersonUserName]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",URL_HEADURL, URL_SHARE, uId]]
                                      title:@"Hi，新朋友，妙定为您准备了1000元见面礼"
                                       type:SSDKContentTypeWebPage];
    [MobClick endEvent:@"invite_friend" label:[SelfPersonInfo getInstance].cnPersonUserName];
    [ShareCustom shareWithContent:shareParams];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"邀请好友-邀请有礼"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邀请好友-邀请有礼"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    inviteDic = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"邀请有礼"];
    
    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [buttonLeft setImage:[UIImage imageNamed:@"backLeftWhite"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    [buttonLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [buttonLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDatas];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_invite PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            inviteDic = [NSMutableDictionary dictionaryWithDictionary:[domain.dataRoot dictionaryForKey:@"data"]];
            uId = [inviteDic stringForKey:@"up_uid"];
            imgRul = [domain.dataRoot stringForKey:@"img"];
            imgShare = [domain.dataRoot stringForKey:@"share_url"];
            [self createView];
        }
    }];
}

-(void)createView
{
       web = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavHeight, self.view.frame.size.width, self.view.frame.size.height - 64)];
        [self.view addSubview:web];
        UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
        tempView.scrollEnabled = NO;
        NSURLRequest *request;
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_HEADURL, imgShare,uId]]];
        [web loadRequest:request];

    
}


- (void)back:(UIBarButtonItem *)btn
{
    if ([web canGoBack]) {
        [web goBack];
        
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:0 forKey:@"WebKitCacheModelPreferenceKey"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        web.delegate = nil;
        [web removeFromSuperview];
        web = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)ruleAction
{
    ruleViewController *rule = [[ruleViewController alloc] init];
    rule.imgRul = imgRul;
    [self.navigationController pushViewController:rule animated:YES];
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
