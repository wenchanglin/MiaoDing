//
//  joinDesignerViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "joinDesignerViewController.h"
#import "joinDesDetailViewController.h"
#import "joinDesResultViewController.h"
@interface joinDesignerViewController ()

@end

@implementation joinDesignerViewController{
    BaseDomain *getData;
    NSMutableDictionary *dataDic;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"设计师入驻"];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getDatas];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT -64-50, SCREEN_WIDTH - 40, 40)];
    [button setBackgroundColor:getUIColor(Color_measureTableTitle)];
    [self.view addSubview:button];
    [button.layer setCornerRadius:1];
    [button.layer setMasksToBounds:YES];
    [button addTarget:self action:@selector(getInToClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"我要申请入驻" forState:UIControlStateNormal];
}

-(void)getDatas
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setObject:@"3" forKey:@"type"];
    
    if ([SelfPersonInfo getInstance].personPhone) {
        [parms setObject:[SelfPersonInfo getInstance].personPhone forKey:@"phone"];
    }
//
    
    [getData getData:URL_GetIntoDesignerImg PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDic = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot objectForKey:@"data"]];
            [self createScrollerView];
            
        }
    }];
}

-(void)createScrollerView
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 60 - 64)];
    [self.view addSubview:scroller];

    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[[dataDic objectForKey:@"img_list"] firstObject] stringForKey:@"img"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         CGFloat scan = image.size.width / image.size.height;
         scroller.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
        [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
        
    }];
    [scroller addSubview:imageDetailDes];
    
}

-(void)getInToClick
{
    if ([dataDic integerForKey:@"is_apply"] == 0) {
        joinDesDetailViewController *joinDes = [[joinDesDetailViewController alloc] init];
        [self.navigationController pushViewController:joinDes animated:YES];
    } else {
        joinDesResultViewController *result = [[joinDesResultViewController alloc] init];
        [self.navigationController pushViewController:result animated:YES];
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
