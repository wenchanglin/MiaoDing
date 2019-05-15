//
//  PayResultViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/17.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "PayResultViewController.h"
#import "perentOrderViewController.h"
@interface PayResultViewController ()
@property(nonatomic,strong)UIButton*toPayBtn;
@property(nonatomic,strong)UIButton*exchageBtn;
@end

@implementation PayResultViewController
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"支付成功"];
    _toPayBtn=[UIButton new];
    [_toPayBtn setTitle:@"查看订单详情" forState:UIControlStateNormal];
    _toPayBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [_toPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _toPayBtn.backgroundColor = [UIColor blackColor];
    _toPayBtn.layer.cornerRadius=4;
    _toPayBtn.tag=200;
    _toPayBtn.layer.borderColor=[UIColor colorWithHexString:@"#9FA0A3"].CGColor;
    _toPayBtn.layer.borderWidth=1;
    [_toPayBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toPayBtn];
    [_toPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH/2+40);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(102);
    }];
   
    _exchageBtn = [UIButton new];
    [_exchageBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    _exchageBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [_exchageBtn setTitleColor:[UIColor colorWithHexString:@"#202020"] forState:UIControlStateNormal];
    _exchageBtn.backgroundColor = [UIColor whiteColor];
    _exchageBtn.layer.cornerRadius=4;
    _exchageBtn.tag=199;
    _exchageBtn.layer.borderColor=[UIColor colorWithHexString:@"#9FA0A3"].CGColor;
    _exchageBtn.layer.borderWidth=1;
    [_exchageBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exchageBtn];
    [_exchageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-SCREEN_WIDTH/2-40);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.height.equalTo(_toPayBtn);
    }];
}
-(void)twoBtnClick:(UIButton*)btn
{
    switch (btn.tag) {
        case 199://返回首页
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 200://
        {
            perentOrderViewController *myOrder = [[perentOrderViewController alloc] init];
            [self.navigationController pushViewController:myOrder animated:YES];
        }break;
        default:
            break;
    }
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
