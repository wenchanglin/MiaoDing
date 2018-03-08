//
//  couPonRulerViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/9.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "couPonRulerViewController.h"

@interface couPonRulerViewController ()

@end

@implementation couPonRulerViewController
{
    BaseDomain *getData;
    NSDictionary *ruleData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"使用规则"];
    [self getDatas];
   }

-(void)getDatas
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [getData getData:URL_CouponRule PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:getData]) {
            ruleData = getData.dataRoot;
             [self createScrollerView];
        }
        
    }];
}

-(void)createScrollerView
{
    
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT  - 64)];
    [self.view addSubview:scroller];
    
    
    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [ruleData stringForKey:@"introduce_img"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGFloat scan =imageDetailDes.image.size.width / imageDetailDes.image.size.height;
        scroller.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
        [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
        [scroller addSubview:imageDetailDes];
        
        
        
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
