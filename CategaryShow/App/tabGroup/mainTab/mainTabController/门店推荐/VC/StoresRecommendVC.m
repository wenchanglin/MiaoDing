//
//  StoresRecommendVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/2/28.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresRecommendVC.h"

@interface StoresRecommendVC ()

@end

@implementation StoresRecommendVC
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"门店推荐";
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
