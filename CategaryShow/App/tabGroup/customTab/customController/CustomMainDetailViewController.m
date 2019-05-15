//
//  CustomMainDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/29.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "CustomMainDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#define webUrl @"html/clo.html"

#define shareUrl @"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/clo.html"
@interface CustomMainDetailViewController ()

@end

@implementation CustomMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试结果";
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createScrollerView];
    // Do any additional setup after loading the view.
}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo shareInstance].userModel.avatar]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:@"想知道我和那个明星的身材最相近么？戳我进来看看"
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&ios=true",shareUrl,_webId]]
                                      title:[NSString stringWithFormat:@"不可想象%@竟然..",[SelfPersonInfo shareInstance].userModel.username]
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];    
    
    
    
}


-(void)createScrollerView
{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:web];
    NSURLRequest *request;
    
    request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",URL_WEBHEADURL,webUrl, _webId]]];
    [web loadRequest:request];
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
