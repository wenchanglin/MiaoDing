//
//  UserDelegateViewController.m
//  TakeAuto
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 黄 梦炜. All rights reserved.
//

#import "UserDelegateViewController.h"
#import "JYHColor.h"
#define USERDELEGATE @"http://itakeauto.com/app/app/agreement.html"
@interface UserDelegateViewController ()

@end

@implementation UserDelegateViewController
{
    BaseDomain *getData;
    NSString *reageString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 64)];
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, 10, 200, 64)];
    [label setText:@"用户协议"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    [bgView addSubview:label];
    
    UIButton *buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 20, 40, 40)];
    [buttonClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [buttonClose setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [bgView addSubview:buttonClose];
    
    [self creatData];
}
-(void)closeView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)creatData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GETPEIZHI PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            reageString = [[getData.dataRoot objectForKey:@"data"] stringForKey:@"user_manual"];
            [self viewCreate];
        }
        
    }];
}

-(void)viewCreate
{
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT  - 64)];
    [self.view addSubview:scroller];
    
    
    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, reageString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
