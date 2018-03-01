//
//  sharePaySuccessViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/7/28.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "sharePaySuccessViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "perentOrderViewController.h"

#define URL_ShareUrl @"web/jquery-obj/static/fx/html/invitation_1000.html"

@interface sharePaySuccessViewController ()

@end

@implementation sharePaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createImage];
    // Do any additional setup after loading the view.
}

-(void)createImage
{
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:image];
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _shareUrl]]];
    
    
    UIButton *cancel = [UIButton new];
    [self.view addSubview:cancel];
    cancel.sd_layout
    .rightSpaceToView(self.view, 19.0 / 375.0 * SCREEN_WIDTH)
    .topSpaceToView(self.view, 145.0 / 667.*SCREEN_HEIGHT)
    .heightIs(60)
    .widthIs(60);
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton new];
    [self.view addSubview:shareBtn];
    
    shareBtn.sd_layout
    .topSpaceToView(cancel, 156.0 / 667.0 * SCREEN_HEIGHT)
    .centerXEqualToView(self.view)
    .heightIs(47)
    .widthIs(191);
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void)shareClick
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

-(void)shareClick
{
    
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _shareUrl]]];
    [shareParams SSDKSetupShareParamsByText:@"做你不敢想的黑科技服饰定制，雅痞还是绅士，成熟还是睿智，先从一件衬衣开始。"
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?pay_ids=%@&uid=%@", URL_HEADURL,URL_ShareUrl, [userd stringForKey:@"payId"],[SelfPersonInfo getInstance].personUserKey]]
                                      title:@"【妙定APP】送你1000元定制红包，手快有，手慢无"
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareContent:shareParams controller:self];
    
    
    
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
