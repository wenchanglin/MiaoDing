//
//  SearchEViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/14.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "SearchEViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface SearchEViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation SearchEViewController
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;
    UIImageView *imageMove;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self settabTitle:@"扫码"];
    [self createView];
}

-(void)createView
{
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // Output
    
    AVCaptureMetadataOutput*  output = [[AVCaptureMetadataOutput alloc] init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    
    if (!session) {
        
        session = [[AVCaptureSession alloc] init];
        
    }
    
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([session canAddInput:input])
        
    {
        
        [session addInput:input];
        
    }
    
    if ([session canAddOutput:output])
        
    {
        
        [session addOutput:output];
        
    }
    
    
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    // Preview
    // Start
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view.layer insertSublayer:layer atIndex:0];
    
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imagev setImage:[UIImage imageNamed:@"searchBack"]];
    [self.view addSubview:imagev];
    
    
    imageMove = [[UIImageView alloc] initWithFrame:CGRectMake((60.0 / 375.0) * SCREEN_WIDTH, 234.0 / 667.0 * SCREEN_HEIGHT-64 , 255.0 / 375.0 * SCREEN_WIDTH, 2)];
    [imageMove setImage:[UIImage imageNamed:@"imageMove"]];
    [self.view addSubview:imageMove];
    
    CABasicAnimation *ani = [self movey:3 y:[NSNumber numberWithInteger:258 ]];
    
    [imageMove.layer addAnimation:ani forKey:nil];
    [session startRunning];
}


-(CABasicAnimation *)movey:(float)time y:(NSNumber *)y

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    
    animation.toValue = y;
    
    animation.duration = time;
    
    animation.removedOnCompletion = YES;//yes的话，又返回原位置了。
    
    animation.repeatCount = MAXFLOAT;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue = nil;
    NSString * result = nil;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSRange range = [stringValue rangeOfString:@"?"]; //现获取要截取的字符串位置
        result = [stringValue substringFromIndex:range.location + 1];
        NSArray *type = [result componentsSeparatedByString:@"&"];
        NSArray *goodsId ;
        NSArray *shopId ;
        NSArray *markerId ;
        NSArray *typeId ;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if ([type count] == 2) {
            goodsId = [type[0] componentsSeparatedByString:@"="];
            typeId = [[type lastObject] componentsSeparatedByString:@"="];
            
            [params setObject:goodsId[1] forKey:goodsId[0]];
            [params setObject:typeId[1] forKey:typeId[0]];
        } else if ([type count] == 4) {
            goodsId = [type[0] componentsSeparatedByString:@"="];
            shopId = [type[1] componentsSeparatedByString:@"="];
            markerId = [type[2] componentsSeparatedByString:@"="];
            typeId = [type[3] componentsSeparatedByString:@"="];
            
            [params setObject:goodsId[1] forKey:goodsId[0]];
            [params setObject:typeId[1] forKey:typeId[0]];
            [params setObject:shopId[1] forKey:shopId[0]];
            [params setObject:markerId[1] forKey:markerId[0]];
        }
        
        
        
        if ([goodsId[0] isEqualToString:@"goods_id"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            if ([params integerForKey:@"type"] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchDZ" object:nil userInfo:params];
            } else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchTK" object:nil userInfo:params];
            }
            
            // 扫码成功，停止扫码会话层活动
            [imageMove.layer removeAllAnimations];
            [session stopRunning];
        }
        
        
        
        
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
