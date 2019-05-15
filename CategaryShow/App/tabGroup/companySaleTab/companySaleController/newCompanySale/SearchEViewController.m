//
//  SearchEViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/14.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "SearchEViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WSLScanView.h"
#import "WSLNativeScanTool.h"
#import "DesignerClothesDetailViewController.h"
#import "designerModel.h"
#import "DiyClothesDetailViewController.h"
#import "JYHNavigationController.h"
@interface SearchEViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong)  WSLNativeScanTool * scanTool;
@property (nonatomic, strong)  WSLScanView * scanView;
@end

@implementation SearchEViewController
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;
    UIImageView *imageMove;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.rdv_tabBarController.tabBarHidden=YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_scanView startScanAnimation];
    [_scanTool sessionStartRunning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.rdv_tabBarController.tabBarHidden=NO;
    [_scanView stopScanAnimation];
    [_scanView finishedHandle];
    [_scanView showFlashSwitch:NO];
    [_scanTool sessionStopRunning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self settabTitle:@"扫码"];
    [self createView];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createView
{
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imagev setImage:[UIImage imageNamed:@"searchBack"]];
    [self.view addSubview:imagev];
    __weak __typeof(self)weakSelf= self;
    
    //构建扫描样式视图
    _scanView = [[WSLScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0)];
    _scanView.scanRetangleRect = CGRectMake(60, 120, (self.view.frame.size.width - 2 * 60),  (self.view.frame.size.width - 2 * 60));
    _scanView.colorAngle = [UIColor blackColor];
    _scanView.photoframeAngleW = 20;
    _scanView.photoframeAngleH = 20;
    _scanView.photoframeLineW = 2;
    _scanView.isNeedShowRetangle = YES;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.animationImage = [UIImage imageNamed:@"imageMove"];//imageNamed:@"scanLine"];
    _scanView.myQRCodeBlock = ^{
    };
    _scanView.flashSwitchBlock = ^(BOOL open) {
        [weakSelf.scanTool openFlashSwitch:open];
    };
    [self.view addSubview:_scanView];
    
    //初始化扫描工具
    _scanTool = [[WSLNativeScanTool alloc] initWithPreview:imagev andScanFrame:_scanView.scanRetangleRect];
    _scanTool.scanFinishedBlock = ^(NSString *scanString) {
//        NSLog(@"扫描结果 %@",scanString);
        [weakSelf scanWithString:scanString];
        [weakSelf.scanView handlingResultsOfScan];
        [weakSelf.scanTool sessionStopRunning];
        [weakSelf.scanTool openFlashSwitch:NO];
    };
    _scanTool.monitorLightBlock = ^(float brightness) {
        //        NSLog(@"环境光感 ： %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if(brightness > 0){
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if(!weakSelf.scanTool.flashOpen){
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    
    [_scanTool sessionStartRunning];
    [_scanView startScanAnimation];
}


-(void)scanWithString:(NSString*)string
{
    NSArray *type = [string componentsSeparatedByString:@"?"];
    NSArray *goodsId ;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    goodsId = [type[1] componentsSeparatedByString:@"="];
    [params setObject:goodsId[1] forKey:goodsId[0]];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_GoodsCategoryWithID_String] parameters:params finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"]count]>0) {
                [params setObject:responseObject[@"data"][@"goods_id"] forKey:@"goods_id"];
                [params setObject:responseObject[@"data"][@"category_id"] forKey:@"category_id"];
                if ([responseObject[@"data"][@"category_id"]integerValue]==1) {//1 定制 2成品
                    DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
                    toButy.goodDic =@{@"id":params[@"goods_id"]}.mutableCopy;
                    [self.navigationController pushViewController:toButy animated:YES];
                }
                else //2
                {
                    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
                    designerModel*models = [designerModel new];
                    models.ID =[params integerForKey:@"goods_id"];
                    designerClothes.model = models;
                    [self.navigationController pushViewController:designerClothes animated:YES];
                }
            }
        }
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
