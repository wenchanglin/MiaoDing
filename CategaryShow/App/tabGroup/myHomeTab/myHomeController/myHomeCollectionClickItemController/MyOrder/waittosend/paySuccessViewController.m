//
//  paySuccessViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/7/28.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "paySuccessViewController.h"
#import "DiyClothesDetailViewController.h"
#import "DesignerClothesDetailViewController.h"
#import "myClothesBagViewController.h"
#import "perentOrderViewController.h"
@interface paySuccessViewController ()

@end

@implementation paySuccessViewController
{
    BaseDomain *getGuid;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"支付完成"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"支付完成"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    getGuid = [BaseDomain getInstance:NO];
    [MobClick endEvent:@"trade_success" label:[SelfPersonInfo getInstance].cnPersonUserName];
    [self settabTitle:@"支付结果"];
    [self createView];
}

-(void)createView
{
    UIImageView *imaegSuccess = [UIImageView new];
    [self.view addSubview:imaegSuccess];
    imaegSuccess .sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 200)
    .heightIs(40)
    .widthIs(40);
    [imaegSuccess setImage:[UIImage imageNamed:@"paySuccess"]];
    
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    
    label.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(imaegSuccess, 20)
    .heightIs(20)
    .widthIs(200);
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"支付成功"];
    
    
    UIButton *back = [UIButton new];
    [self.view addSubview:back];
    
    back.sd_layout
    .leftSpaceToView(self.view, SCREEN_WIDTH / 2 - 101 - 20)
    .topSpaceToView(label, 40)
    .heightIs(33)
    .widthIs(101);
    [back setImage:[UIImage imageNamed:@"backMain"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backMainClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *lookOrder = [UIButton new];
    [self.view addSubview:lookOrder];
    
    lookOrder.sd_layout
    .leftSpaceToView(self.view, SCREEN_WIDTH / 2 + 20)
    .topSpaceToView(label, 40)
    .heightIs(33)
    .widthIs(101);
    [lookOrder setImage:[UIImage imageNamed:@"lookOrder"] forState:UIControlStateNormal];
    [lookOrder addTarget:self action:@selector(lookOrder) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self createData];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)lookOrder
{
    DiyClothesDetailViewController *toBuy = [[DiyClothesDetailViewController alloc] init];
    
    DesignerClothesDetailViewController *buyDesigner = [[DesignerClothesDetailViewController alloc] init];
    
    myClothesBagViewController *bag = [[myClothesBagViewController alloc] init];
    
    perentOrderViewController *perent = [[perentOrderViewController alloc] init];
   
    
    
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[toBuy class]] || [controller isKindOfClass:[buyDesigner class]]||[controller isKindOfClass:[bag class]] || [controller isKindOfClass:[perent class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:NO]; //跳转
    }

    if (![target isKindOfClass:[perent class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"realToOrder" object:nil];
    }
    
    
}

-(void)backMainClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void)createData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"6" forKey:@"id"];
    [getGuid getData:URL_GetYingDao PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            sharePaySuccessViewController *share = [[sharePaySuccessViewController alloc] init];
            share.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            share.shareUrl = [[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"img_urls"] firstObject];
            
            [self presentViewController:share animated:YES completion:nil];
            
        }
    }];
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
