//
//  ruleViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/12.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ruleViewController.h"

@interface ruleViewController ()

@end

@implementation ruleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"活动规则";
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:topView];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self createScrollerView];
    // Do any additional setup after loading the view.
}
-(void)createScrollerView
{
    
    
    
    
    
//   UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
//    [self.view addSubview:web];
//    UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
//    tempView.scrollEnabled = NO;
//    NSURLRequest *request;
//    
//    
//    request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/huodong.html"]];
//   
//    
//    
//    
//    [web loadRequest:request];
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT  - 64)];
    [self.view addSubview:scroller];
    
    
    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _imgRul]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
