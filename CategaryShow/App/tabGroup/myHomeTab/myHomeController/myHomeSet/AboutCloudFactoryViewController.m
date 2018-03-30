//
//  AboutCloudFactoryViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "AboutCloudFactoryViewController.h"

@interface AboutCloudFactoryViewController ()

@end

@implementation AboutCloudFactoryViewController
{
    UIImageView *Logo;
    UILabel *BanBen;
    UILabel *WXLabel;
    UILabel *CopyRight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"关于妙定"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createView];
    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createView
{
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    Logo = [UIImageView new];
    [self.view addSubview:Logo];
    Logo.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 120)
    .widthIs(80)
    .heightIs(80);
//    [Logo.layer setCornerRadius:40];
    [Logo.layer setMasksToBounds:YES];
    [Logo setContentMode:UIViewContentModeScaleAspectFit];
    [Logo setImage:[UIImage imageNamed:@"AboutMD"]];
    
    BanBen = [UILabel new];
    [self.view addSubview:BanBen];
    
    BanBen.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(Logo,10)
    .widthIs(200)
    .heightIs(20);
    [BanBen setTextColor:[UIColor lightGrayColor]];
    [BanBen setText:[NSString stringWithFormat:@"当前版本:%@",currentVersion]];
    [BanBen setTextAlignment:NSTextAlignmentCenter];
    [BanBen setFont:[UIFont systemFontOfSize:14]];
    
    WXLabel =[UILabel new];
    [self.view addSubview:WXLabel];
    WXLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 80)
    .widthIs(SCREEN_WIDTH)
    .heightIs(20);
     [WXLabel setTextAlignment:NSTextAlignmentCenter];
    [WXLabel setTextColor:[UIColor lightGrayColor]];
    [WXLabel setText:@"Copyright©2015-2016"];
    [WXLabel setFont:[UIFont systemFontOfSize:14]];
    
    CopyRight =[UILabel new];
    [self.view addSubview:CopyRight];
    CopyRight.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(WXLabel, 0)
    .widthIs(250)
    .heightIs(40);
    [CopyRight setNumberOfLines:2];
    [CopyRight setTextAlignment:NSTextAlignmentCenter];
    [CopyRight setTextColor:[UIColor lightGrayColor]];
    [CopyRight setText:@"杭州云工场科技有限公司"];
    [CopyRight setFont:[UIFont systemFontOfSize:14]];
    
    
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
