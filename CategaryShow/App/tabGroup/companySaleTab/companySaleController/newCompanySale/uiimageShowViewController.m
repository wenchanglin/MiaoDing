//
//  uiimageShowViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/22.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "uiimageShowViewController.h"
#import "GHContextMenuView.h"
#import "LazyFadeInView.h"
@interface uiimageShowViewController ()<GHContextOverlayViewDelegate, GHContextOverlayViewDataSource,LazyFadeInViewDelegate>

@end

@implementation uiimageShowViewController
{
    NSMutableArray *labels;
    NSMutableArray *numArr;
    NSMutableArray *dataArr;
    UIButton *buttonClose;
    UILabel *subName;
    UILabel *name;
    
}
-(id)init
{
    self = [super init];
    if (self) {
        }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH  , self.view.frame.size.height)];
        [self.view addSubview:_imageView];
        
        subName = [UILabel new];
        [self.view addSubview:subName];
        
    }
    
    
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL, _imageUrl]]];
    _imageView.contentMode =  UIViewContentModeScaleAspectFill;
//    [_imageView.layer setCornerRadius:4];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _imageView.clipsToBounds  = YES;
    _imageView.userInteractionEnabled = YES;
    
    
    
   
    
    subName.sd_layout
    .bottomSpaceToView(self.view, 30)
    .centerXEqualToView(self.view)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH);
    [subName setText:[_goodDic stringForKey:@"sub_name"]];
    [subName setFont:[UIFont systemFontOfSize:12]];
    [subName setTextColor:getUIColor(Color_shadow)];
    [subName setTextAlignment:NSTextAlignmentCenter];
    name = [UILabel new];
    [self.view addSubview:name];
    
    name.sd_layout
    .bottomSpaceToView(subName, 12)
    .centerXEqualToView(self.view)
    .heightIs(30)
    .widthIs(SCREEN_WIDTH);
    [name setText:[_goodDic stringForKey:@"name"]];
    [name setFont:[UIFont systemFontOfSize:20]];
    [name setTextColor:getUIColor(Color_shadow)];
    [name setTextAlignment:NSTextAlignmentCenter];
    
    
    

}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view.
}

-(void)tapClick
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:_index] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapClick" object:nil userInfo:dic];
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
