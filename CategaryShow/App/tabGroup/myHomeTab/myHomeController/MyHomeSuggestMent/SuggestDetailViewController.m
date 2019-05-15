//
//  SuggestDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "SuggestDetailViewController.h"

@interface SuggestDetailViewController ()

@end

@implementation SuggestDetailViewController
{
    BaseDomain *getData;
    NSMutableDictionary *detailDic;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"帮助详情"];
    getData = [BaseDomain getInstance:NO];
   
    [self.view setBackgroundColor:getUIColor(Color_background)];
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_detailId forKey:@"id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MineHelpDetail_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            detailDic = [NSMutableDictionary dictionaryWithDictionary:[responseObject dictionaryForKey:@"data"]];
            [self createView];
        }
    }];

}

-(void)createView
{
    
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, NavHeight, SCREEN_WIDTH - 60, 40)];
    [labelTitle setText:[detailDic stringForKey:@"name"]];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [labelTitle setTextColor:getUIColor(Color_suggestLargeTitle)];
    [self.view addSubview:labelTitle];
    
    
    
    UITextView *contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, SCREEN_WIDTH - 10, SCREEN_HEIGHT - 120)];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setText:[detailDic stringForKey:@"content"]];
    [contentLabel setFont:[UIFont systemFontOfSize:14]];
    [contentLabel setTextColor:getUIColor(Color_suggestLargeTitle)];
    [contentLabel setUserInteractionEnabled:NO];
    [self.view addSubview:contentLabel];
    
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
