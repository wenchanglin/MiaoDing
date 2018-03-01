//
//  CustomMainViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "CustomMainViewController.h"
#import "SelfPersonInfo.h"
#import "YHFlowerMenu.h"
#import "STAlertView.h"
#import "TXHRrettyRuler.h"
#import "MainTabDetailViewController.h"
#import "CustomMainDetailViewController.h"
@interface CustomMainViewController ()<TXHRrettyRulerDelegate>

@property (nonatomic, strong) YHFlowerMenu *menu;

@end

@implementation CustomMainViewController {
    UILabel *cmShowLabel;
    UIImageView *showMan;
    UILabel *kgShowLabel;
    BaseDomain *getData;
    NSString *height;
    NSString *weight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    height = @"175";
    weight = @"65";
    getData = [BaseDomain getInstance:NO];
    self.title = @"穿衣测试";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    [buttonRight setTitle:@"下一步" forState:UIControlStateNormal];
    [buttonRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    [buttonRight addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    [self createBgImage];
    [self createRuler];
    [self createLabelShow];
  
}

-(void)nextStepClick{
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 25 ; i < 60; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [array addObject:str];
    }
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:array andHeadTitle:@"选择年龄" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:height forKey:@"height"];
        [params setObject:weight forKey:@"weight"];
        [params setObject:choiceString forKey:@"age"];
        
        
        [getData getData:URL_GetActorData PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            if ([self checkHttpResponseResultStatus:getData]) {
                CustomMainDetailViewController *mainDetail = [[CustomMainDetailViewController alloc] init];
                mainDetail.webId = [[domain.dataRoot dictionaryForKey:@"data"] stringForKey:@"id"];
                [self.navigationController pushViewController:mainDetail animated:YES];

            }
        }];
        
        [pickerView dismissPicker];
    }];
    [pickerView show];
    
   
}

-(void)createBgImage
{
    showMan = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:showMan];
    showMan.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,114)
    .widthIs(251 / 2.4)
    .heightIs(984 / 2.4);
    [showMan setImage:[UIImage imageNamed:@"wearClothesMan"]];
}

-(void)createRuler
{
    
    // 2.创建 TXHRrettyRuler 对象 并设置代理对象
    TXHRrettyRuler *ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(self.view.frame.size.width - ([UIScreen mainScreen].bounds.size.width - 70 * 2) / 2 - 50, self.view.frame.size.height / 2 - 100, [UIScreen mainScreen].bounds.size.width - 70 * 2, 110)];
    ruler.tag = 7;
    ruler.rulerDeletate = self;
    ruler.circle = NO;
    CGAffineTransform rotation1 = CGAffineTransformMakeRotation( - M_PI_2);
    [ruler setTransform:rotation1];
    [ruler showRulerScrollViewWithCount:250 average:[NSNumber numberWithFloat:1] currentValue:175.0f smallMode:NO];
    [self.view addSubview:ruler];
    
    
    
    TXHRrettyRuler *ruler1 = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - ([UIScreen mainScreen].bounds.size.width - 70 * 2) / 2, self.view.frame.size.height- 95, [UIScreen mainScreen].bounds.size.width - 70 * 2, 110)];
    ruler1.tag = 6;
    ruler1.rulerDeletate = self;
    ruler1.circle = YES;
    
    [ruler1 showRulerScrollViewWithCount:200 average:[NSNumber numberWithFloat:1] currentValue:60.0f smallMode:NO];
    [self.view addSubview:ruler1];
    
    
//    [ruler setTransform:rotation]
    // Do any additional setup after loading the view.
}

-(void)createLabelShow
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 40, 20)];
    [label setText:@"身高:"];
    [label setTextColor:getUIColor(Color_myTabIconTitleColor)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label];
    
    cmShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 65, 20)];
    [cmShowLabel setTextColor:getUIColor(Color_myTabIconTitleColor)];
    [cmShowLabel setFont:[UIFont systemFontOfSize:14]];
    [cmShowLabel setText:@"175cm"];
    [self.view addSubview:cmShowLabel];
    
  
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 40, 20)];
    [label1 setText:@"体重:"];
    [label1 setTextColor:getUIColor(Color_myTabIconTitleColor)];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label1];
    
    kgShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 65, 20)];
    [kgShowLabel setTextColor:getUIColor(Color_myTabIconTitleColor)];
    [kgShowLabel setFont:[UIFont systemFontOfSize:14]];
    [kgShowLabel setText:@"65cm"];
    [self.view addSubview:kgShowLabel];
    
 
}

-(void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView TxHRretty:(UIView *)TxHRretty
{
    if (TxHRretty.tag == 7) {
        height = [NSString stringWithFormat:@"%.0f", rulerScrollView.rulerValue];
        [cmShowLabel setText:[NSString stringWithFormat:@"%.0fcm",rulerScrollView.rulerValue]];
        
    } else if ( TxHRretty.tag == 6) {
        [kgShowLabel setText:[NSString stringWithFormat:@"%.0fkg",rulerScrollView.rulerValue]];
        weight = [NSString stringWithFormat:@"%.0f", rulerScrollView.rulerValue];
    }
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
