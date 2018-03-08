//
//  joinDesResultViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "joinDesResultViewController.h"

@interface joinDesResultViewController ()

@end

@implementation joinDesResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self settabTitle:@"入驻反馈"];
    [self createView];
}

-(void)createView
{
    UIImageView *success = [UIImageView new];
    [self.view addSubview:success];
    success.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, self.view.frame.size.height / 3)
    .heightIs(75)
    .widthIs(75);
    [success setImage:[UIImage imageNamed:@"yuyuesuccess"]];
    
    UILabel *worningLabel = [UILabel new];
    [self.view addSubview:worningLabel];

    worningLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(success, 10)
    .heightIs(60)
    .widthIs(SCREEN_WIDTH);
    [worningLabel setFont:[UIFont systemFontOfSize:14]];
    [worningLabel setNumberOfLines:0];
    [worningLabel setText:@"您的入驻申请已经提交成功。\n我们将在七个工作日内审核完毕"];
    [worningLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *button = [UIButton new];
    [self.view addSubview:button];
    button.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(worningLabel, 40)
    .heightIs(40)
    .widthIs(220);
    [button.layer setCornerRadius:1];
    [button.layer setMasksToBounds:YES];
    [button setTitle:@"返回首页" forState:UIControlStateNormal];
    [button setBackgroundColor:getUIColor(Color_buyColor)];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

-(void)backToMain
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
