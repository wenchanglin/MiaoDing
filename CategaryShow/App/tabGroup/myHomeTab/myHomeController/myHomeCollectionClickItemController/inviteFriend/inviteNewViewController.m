
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
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@邀请你加入妙定定制",[SelfPersonInfo getInstance].cnPersonUserName]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@",URL_HEADURL, URL_SHARE, uId]]
                                      title:@"邀请有礼"
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    inviteDic = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"邀请有礼";
    
//    inviteBackImg = [UIImageView new];
//    [self.view addSubview:inviteBackImg];
//    inviteBackImg.sd_layout
//    .leftSpaceToView(self.view, 16)
//    .topSpaceToView(self.view, 16 + 64)
//    .rightSpaceToView(self.view, 16)
//    .bottomSpaceToView(self.view, 16);
//    [inviteBackImg setImage:[UIImage imageNamed:@"inviteBack"]];
//     [inviteBackImg setUserInteractionEnabled:YES];
    
    
    
    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [buttonLeft setImage:[UIImage imageNamed:@"backLeft"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    [buttonLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [buttonLeft addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDatas];
    
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
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
   
       web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        [self.view addSubview:web];
        UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
        tempView.scrollEnabled = NO;
        NSURLRequest *request;
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_HEADURL, imgShare,uId]]];
        [web loadRequest:request];
//    EWMImg = [UIImageView new];
//    [inviteBackImg addSubview:EWMImg];
//    EWMImg.sd_layout
//    .topSpaceToView(inviteBackImg, 42)
//    .centerXEqualToView(inviteBackImg)
//    .heightIs(110.0 / 375.0 * SCREEN_WIDTH)
//    .widthIs(110.0 / 375.0 * SCREEN_WIDTH);
//    [EWMImg sd_setImageWithURL:[NSURL URLWithString:[inviteDic stringForKey:@"ewm"]]];
//   
//    
//    
//    UILabel *FirstTitle = [UILabel new];
//    [inviteBackImg addSubview:FirstTitle];
//    
//    FirstTitle.sd_layout
//    .topSpaceToView(EWMImg, 77)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(15)
//    .rightSpaceToView(inviteBackImg, 16);
//    [FirstTitle setText:@"分享二维码给好友"];
//    [FirstTitle setFont:[UIFont systemFontOfSize:12]];
//    [FirstTitle setTextColor:[UIColor lightGrayColor]];
//    
//    UILabel *FirstDetail = [UILabel new];
//    [inviteBackImg addSubview:FirstDetail];
//    
//    FirstDetail.sd_layout
//    .topSpaceToView(FirstTitle, 10)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(15)
//    .rightSpaceToView(inviteBackImg, 16);
//    [FirstDetail setText:@"TA得优惠，您得奖励"];
//    [FirstDetail setFont:[UIFont systemFontOfSize:24]];
//    [FirstDetail setTextColor:[UIColor blackColor]];
//    
//    
//    UILabel *SecondTitle = [UILabel new];
//    [inviteBackImg addSubview:SecondTitle];
//    
//    SecondTitle.sd_layout
//    .topSpaceToView(FirstDetail, 14)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(15)
//    .rightSpaceToView(inviteBackImg, 16);
//    [SecondTitle setText:@"奖励介绍"];
//    [SecondTitle setFont:[UIFont systemFontOfSize:12]];
//    [SecondTitle setTextColor:[UIColor lightGrayColor]];
//
//    UILabel *SecondDetail = [UILabel new];
//    [inviteBackImg addSubview:SecondDetail];
//    SecondDetail.sd_layout
//    .topSpaceToView(SecondTitle, 10)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(20)
//    .rightSpaceToView(inviteBackImg, 16);
//    [SecondDetail setText:@"您可获得订单实付金额的1%作为奖励"];
//    [SecondDetail setFont:[UIFont systemFontOfSize:16]];
//    [SecondDetail setTextColor:getUIColor(Color_DZClolor)];
//
//    UILabel *ThirdTitle = [UILabel new];
//    [inviteBackImg addSubview:ThirdTitle];
//    
//    ThirdTitle.sd_layout
//    .topSpaceToView(SecondDetail, 14)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(15)
//    .rightSpaceToView(inviteBackImg, 16);
//    [ThirdTitle setText:@"已经邀请好友"];
//    [ThirdTitle setFont:[UIFont systemFontOfSize:12]];
//    [ThirdTitle setTextColor:[UIColor lightGrayColor]];
//    
//    
//    UILabel *ThirdDetail = [UILabel new];
//    [inviteBackImg addSubview:ThirdDetail];
//    ThirdDetail.sd_layout
//    .topSpaceToView(ThirdTitle, 10)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(20)
//    .rightSpaceToView(inviteBackImg, 16);
//    [ThirdDetail setText:[NSString stringWithFormat:@"您已邀请 %@ 人", [inviteDic stringForKey:@"invite_num"]]];
//    [ThirdDetail setFont:[UIFont systemFontOfSize:16]];
//    [ThirdDetail setTextColor:getUIColor(Color_DZClolor)];
//   
//    UILabel *FourthTitle = [UILabel new];
//    [inviteBackImg addSubview:FourthTitle];
//    
//    FourthTitle.sd_layout
//    .topSpaceToView(ThirdDetail, 14)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(15)
//    .rightSpaceToView(inviteBackImg, 16);
//    [FourthTitle setText:@"已获得奖励"];
//    [FourthTitle setFont:[UIFont systemFontOfSize:12]];
//    [FourthTitle setTextColor:[UIColor lightGrayColor]];
//    
//    UILabel *FourthDetail = [UILabel new];
//    [inviteBackImg addSubview:FourthDetail];
//    FourthDetail.sd_layout
//    .topSpaceToView(FourthTitle, 10)
//    .leftSpaceToView(inviteBackImg, 30)
//    .heightIs(20)
//    .rightSpaceToView(inviteBackImg, 16);
//    [FourthDetail setText:[NSString stringWithFormat:@"您已获得奖励RMB %@ 元", [inviteDic stringForKey:@"money"]]];
//    [FourthDetail setFont:[UIFont systemFontOfSize:16]];
//    [FourthDetail setTextColor:getUIColor(Color_DZClolor)];
//    
//    UIButton *RuleEnter = [UIButton new];
//    [inviteBackImg addSubview:RuleEnter];
//    
//    RuleEnter.sd_layout
//    .topSpaceToView(FourthDetail, 38)
//    .centerXEqualToView(inviteBackImg)
//    .heightIs(20)
//    .widthIs(60);
//    [RuleEnter setTitle:@"活动规则 >>" forState:UIControlStateNormal];
//    [RuleEnter setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [RuleEnter.titleLabel setFont:[UIFont systemFontOfSize:10]];
//    [RuleEnter addTarget:self action:@selector(ruleAction) forControlEvents:UIControlEventTouchUpInside];
//    
    
}


- (void)back:(UIBarButtonItem *)btn
{
    if ([web canGoBack]) {
        [web goBack];
        
    }else{
        [self.view resignFirstResponder];
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
