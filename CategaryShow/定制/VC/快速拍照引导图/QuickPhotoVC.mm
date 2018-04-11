
//
//  QuickPhotoVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/4.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "QuickPhotoVC.h"
#import "sys/utsname.h"
#import "photoModel.h"
#import "photoTableViewCell.h"
#import <CoreMotion/CoreMotion.h>
#import "opencv2/opencv.hpp"
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/core/core_c.h>
#import <opencv2/features2d/features2d.hpp>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#import "takePhotoCollectionViewCell.h"
#import "LodingViewController.h"
#import "HttpRequestTool.h"
#import <Photos/Photos.h>
#import "NewDiyPersonalityVC.h"
#define LabelX backgroundView.center.x / 16 - 7.5
#define LeftLabelY  backgroundView.center.y
#define DownLabelX  backgroundView.center.x
#define DownLabelY  LeftLabelY * 1.66 - 5
@interface QuickPhotoVC ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong) UILabel *leftLabel;

@end

@implementation QuickPhotoVC
{
    UITableView *photoTable;
    NSMutableArray *photoModelArray;
    UIImagePickerController *imagePickerController;
    NSInteger currentStep;
    NSArray *backgroundImages;
    UIImageView *backgroundView;
    CMMotionManager *motionManager;
    UILabel *downLabel;
    UIButton *shutButton;
    UIButton *retakeButton;
    NSString *stringImage;
    NSString *BiLi;
    NSString *y_position;
    BaseDomain *postData;
    UICollectionView *photoCollection;
    UIButton *shutMInebutton;
    CGFloat area;
    BOOL canShut;
    UIButton *helpBtn;
    UIView *cameraResult;
    UISwitch *chooseSwitch;
    NSMutableArray * iphone7Arr;
    NSMutableArray *photoDataArray;
    CGFloat ppi;
    CGFloat lowPoint;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithImage:[self reSizeImage:[UIImage imageNamed:@"backLeftWhite"] toSize:CGSizeMake(9, 16)] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = item;
    [self settabTitle:@"拍照结果"];
    canShut = NO;
    y_position = NULL;
    iphone7Arr = [NSMutableArray array];
    photoDataArray = [NSMutableArray array];
    postData = [BaseDomain getInstance:NO];
    photoModelArray = [NSMutableArray array];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"重拍" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    ppi = [self getPPi];
    NSArray *array = [NSArray arrayWithObjects:@"正面",@"左侧", @"背面", @"右侧", nil];
    for (int i = 0; i < [array count]; i ++) {
        photoModel *model = [photoModel new];
        model.photoName = array[i];
        model.photo = [UIImage new];
        [photoModelArray addObject:model];
    }
    
    backgroundImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"front"], [UIImage imageNamed:@"left"], [UIImage imageNamed:@"behind"],[UIImage imageNamed:@"right"], nil];
    [self createPhotoTable];
    [self takePhoto];
//    [self createPhotoShow];
}
-(CGFloat)getPPi
{
    //    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGFloat x;
    NSString *strDe = [self deviceVersion];
    if ([strDe isEqualToString:@"5S"] || [strDe isEqualToString:@"5"]) {
        x = sqrt(SCREEN_HEIGHT * SCREEN_HEIGHT + SCREEN_WIDTH *SCREEN_WIDTH) / 3.5;
    } else if ([strDe isEqualToString:@"6"] || [strDe isEqualToString:@"6S"]|| [strDe isEqualToString:@"7"]|| [strDe isEqualToString:@"8"]) {
        //         x = sqrt(SCREEN_HEIGHT *scale_screen * SCREEN_HEIGHT *scale_screen + SCREEN_WIDTH *scale_screen *SCREEN_WIDTH *scale_screen) / 4.5;
        x = 326;
        lowPoint = 190;
    } else if([strDe isEqualToString:@"6P"]||[strDe isEqualToString:@"6SP"]|| [strDe isEqualToString:@"7P"]|| [strDe isEqualToString:@"8P"])
    {
        //        x = sqrt(SCREEN_HEIGHT *scale_screen * SCREEN_HEIGHT *scale_screen + SCREEN_WIDTH *scale_screen *SCREEN_WIDTH *scale_screen) / 5.5;
        x = 401;
        lowPoint = 210;
    }
    else //iphone X
    {
        x= 458;
        lowPoint = 230;
    }
    
    return x;
}

-(void)retake
{
    [photoModelArray removeAllObjects];
    [photoDataArray removeAllObjects];
    stringImage = nil;
    BiLi = nil;
    NSArray *array = [NSArray arrayWithObjects:@"正面",@"左侧", @"背面", @"右侧", nil];
    for (int i = 0; i < [array count]; i ++) {
        photoModel *model = [photoModel new];
        model.photoName = array[i];
        model.photo = [UIImage new];
        [photoModelArray addObject:model];
    }
    [photoTable reloadData];
    [self takePhoto];
    
}
-(void)takePhoto
{
    currentStep = 1;
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate   = self;
    imagePickerController.showsCameraControls = YES;
    
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    backgroundView = [[UIImageView alloc] initWithImage:backgroundImages[currentStep - 1]];;
    //    DiyCameraViewController *diy = [[DiyCameraViewController alloc] init];
    //    imagePickerController.cameraOverlayView = diy.view;
    [backgroundView setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height)];
    [imagePickerController.view addSubview:backgroundView];
    
    shutMInebutton = [[UIButton alloc] initWithFrame:CGRectMake(imagePickerController.view.frame.size.width / 2 - 30, imagePickerController.view.frame.size.height - 80, 60, 60)];
    [shutMInebutton.layer setCornerRadius:30];
    [shutMInebutton.layer setMasksToBounds:YES];
    [shutMInebutton setImage:[UIImage imageNamed:@"Noshutten"] forState:UIControlStateNormal];
    [shutMInebutton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [imagePickerController.view addSubview:shutMInebutton];
    
    helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    [helpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    [helpBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(helpClick) forControlEvents:UIControlEventTouchUpInside];
    [imagePickerController.view addSubview:helpBtn];
    
    
    //    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70 - 40, 5, 40, 40)];
    //    [title setFont:[UIFont systemFontOfSize:16]];
    //    [title setTextColor:[UIColor whiteColor]];
    //    [imagePickerController.view addSubview:title];
    //    [title setText:@"精细"];
    //
    //    chooseSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 10, 55, 40)];
    //    [imagePickerController.view addSubview:chooseSwitch];
    
    CGFloat H = 29.0 / 3000.0 * _bodyHeight/ 0.81;
    UIView *lindDown = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint, 180, 1)];
    [lindDown setBackgroundColor:[UIColor whiteColor]];
    [imagePickerController.view addSubview:lindDown];
    
    
    UIView *lindUp = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 180, 1)];
    [lindUp setBackgroundColor:[UIColor whiteColor]];
    [imagePickerController.view addSubview:lindUp];
    
    
    UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
    [lineLeft setBackgroundColor:[UIColor whiteColor]];
    [imagePickerController.view addSubview:lineLeft];
    
    UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 89, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
    [lineRight setBackgroundColor:[UIColor whiteColor]];
    [imagePickerController.view addSubview:lineRight];
    
    UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
    [centerLine setBackgroundColor:[UIColor whiteColor]];
    [imagePickerController.view addSubview:centerLine];

    [self createCoreMotionOnCameraView];
    
    __weak __typeof(self) weakSelf = self;
    [self presentViewController:imagePickerController animated:YES completion:^{
        [weakSelf createMoveLabelWithTheGravityInCaremaView];
    }];
}

-(void)helpClick
{
    [imagePickerController dismissViewControllerAnimated:NO completion:nil];
    
    LodingViewController *lodin = [[LodingViewController alloc] init];
    [self.navigationController pushViewController:lodin animated:YES];
}

-(void)takePicture
{
    if (canShut) {
        [backgroundView removeFromSuperview];
        [shutMInebutton removeFromSuperview];
        [_leftLabel removeFromSuperview];
        [downLabel removeFromSuperview];
        [imagePickerController takePicture];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拍摄问题" message:@"请确保手机垂直于地面（通过调整手机拍摄角度将左边与下边的蓝色小球移动至白色圈内）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    //    [progressHud hideAnimated:YES];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* imgTake = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *imageFix = [self fixOrientation:imgTake];
//    UIImage *resImg = [self imageHog:imageFix];
    photoModel *model = photoModelArray[currentStep - 1];
    model.photo = imageFix;
    if (imageFix == nil) {
        [imagePickerController dismissViewControllerAnimated:NO completion:nil];
        
        if (currentStep <= 4) {
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate   = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.cameraDevice  = UIImagePickerControllerCameraDeviceRear;
            backgroundView = [[UIImageView alloc] initWithImage:backgroundImages[currentStep - 1]];;
            [backgroundView setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height)];
            [imagePickerController.view addSubview:backgroundView];
            shutMInebutton = [[UIButton alloc] initWithFrame:CGRectMake(imagePickerController.view.frame.size.width / 2 - 30, imagePickerController.view.frame.size.height - 80, 60, 60)];
            [shutMInebutton.layer setCornerRadius:30];
            [shutMInebutton.layer setMasksToBounds:YES];

            [shutMInebutton setImage:[UIImage imageNamed:@"Noshutten"] forState:UIControlStateNormal];
            [shutMInebutton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [imagePickerController.view addSubview:shutMInebutton];
            
            
            CGFloat H = 29.0 / 3000.0 * _bodyHeight / 0.81;
            
            UIView *lindDown = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint, 180, 1)];
            [lindDown setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lindDown];
            
            
            UIView *lindUp = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 180, 1)];
            [lindUp setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lindUp];
            
            
            UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
            [lineLeft setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lineLeft];
            
            UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 89, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
            [lineRight setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lineRight];
            UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
            [centerLine setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:centerLine];
            //[backgroundView setFrame:imagePickerController.view.frame];
            //imagePickerController.cameraOverlayView = backgroundView;
            [self createCoreMotionOnCameraView];
            __weak typeof(self) weakself = self;
            [self presentViewController:imagePickerController animated:YES completion:^{
                [weakself createMoveLabelWithTheGravityInCaremaView];
            }];
        }
        else{
            
            [photoTable reloadData];
        }
    } else {
        
        NSData *imgData = UIImageJPEGRepresentation(imageFix, 1);
        NSString * base64 = [imgData base64EncodedStringWithOptions:kNilOptions];
        [photoDataArray addObject:imgData];
        if (stringImage) {
            stringImage = [NSString stringWithFormat:@"%@,%@", stringImage, base64];
        } else {
            stringImage = base64;
        }
        
        
        [imagePickerController dismissViewControllerAnimated:NO completion:nil];
        
        if (currentStep < 4) {
            
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate   = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.cameraDevice  = UIImagePickerControllerCameraDeviceRear;

            
            currentStep++;
            backgroundView = [[UIImageView alloc] initWithImage:backgroundImages[currentStep - 1]];;
            [backgroundView setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height)];
            [imagePickerController.view addSubview:backgroundView];
            
            shutMInebutton = [[UIButton alloc] initWithFrame:CGRectMake(imagePickerController.view.frame.size.width / 2 - 30, imagePickerController.view.frame.size.height - 80, 60, 60)];
            [shutMInebutton.layer setCornerRadius:30];
            [shutMInebutton.layer setMasksToBounds:YES];
            [shutMInebutton setImage:[UIImage imageNamed:@"Noshutten"] forState:UIControlStateNormal];
            [shutMInebutton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
            [imagePickerController.view addSubview:shutMInebutton];
            
            
            
            CGFloat H = 29.0 / 3000.0 * _bodyHeight/ 0.81;
            UIView *lindDown = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint, 180, 1)];
            [lindDown setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lindDown];
            
            
            UIView *lindUp = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 180, 1)];
            [lindUp setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lindUp];
            
            
            UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
            [lineLeft setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lineLeft];
            
            UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 89, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
            [lineRight setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:lineRight];
            
            UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
            [centerLine setBackgroundColor:[UIColor whiteColor]];
            [imagePickerController.view addSubview:centerLine];
            
            [self createCoreMotionOnCameraView];
            [self presentViewController:imagePickerController animated:YES completion:^{
                [self createMoveLabelWithTheGravityInCaremaView];
            }];
        }
        else{
            
            [photoTable reloadData];
        }
    }
}
-(void)createMoveLabelWithTheGravityInCaremaView
{
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(LabelX,LeftLabelY,15,15)];
    _leftLabel.layer.cornerRadius = 7.5;
    _leftLabel.clipsToBounds      = YES;
    _leftLabel.backgroundColor    = [UIColor blueColor];
    [imagePickerController.view addSubview:_leftLabel];
    
    downLabel = [[UILabel alloc]initWithFrame:CGRectMake(DownLabelX,DownLabelY,15,15)];
    downLabel.layer.cornerRadius = 7.5;
    downLabel.clipsToBounds      = YES;
    downLabel.backgroundColor    = [UIColor blueColor];
    [imagePickerController.view addSubview:downLabel];
    
}


-(void)createCoreMotionOnCameraView
{
    motionManager = [[CMMotionManager alloc] init];
    if (motionManager.deviceMotionAvailable) {
        
        motionManager.deviceMotionUpdateInterval = 0.01;
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            //前后摇晃时候与Y轴的夹角
            double fTheta = atan2(motion.gravity.z, sqrt(motion.gravity.x * motion.gravity.x + motion.gravity.y * motion.gravity.y)) / M_PI * 180.0;
            //左右摇晃时与Y轴的夹角
            double yTheta = atan2(motion.gravity.x, sqrt(motion.gravity.z * motion.gravity.z + motion.gravity.y * motion.gravity.y)) / M_PI * 180.0;
            [UIView animateWithDuration:1 animations:^{
                _leftLabel.frame  = CGRectMake(LabelX, LeftLabelY + fTheta * 5, 15, 15);
                downLabel.frame  = CGRectMake( DownLabelX + yTheta * 5, DownLabelY , 15, 15);
            }];
            if (fTheta > -5 && fTheta < 5 && yTheta < 1 && yTheta > -1){
                
                canShut = YES;
                [shutMInebutton setImage:[UIImage imageNamed:@"shutten"] forState:UIControlStateNormal];
            } else {
                canShut = NO;
              
                [shutMInebutton setImage:[UIImage imageNamed:@"Noshutten"] forState:UIControlStateNormal];
            }
            
        }];
    }
    
    
    
}

#pragma ---mark camera界面产生时候调用此方法
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    

    //首先判断当前设备的版本(主要是iOS9修改了camera界面底层的实现)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        //在相机界面中进行循环遍历出shutterButton
        // NSLog(@"1:  %@", viewController.view.subviews);
        for (UIView *tmpView in viewController.view.subviews) {

            //删除拍照界面顶部的工具条 (iOS9之后设置topBar隐藏属性是不能够隐藏掉那个前置摄像头)

            //获取重拍按钮
            for (UIView *tmpView2 in tmpView.subviews) {
//                NSLog(@"448:2: %@", [[tmpView2 class]description]);
                if( [[[tmpView2 class]description]isEqualToString:@"PLCropOverlayBottomBar"])
                {
                    UIButton *retakeButtons=tmpView2.subviews[0].subviews[0];
                    UIButton * used = tmpView2.subviews[0].subviews[2];
                    [retakeButtons setImage:[UIImage imageNamed:@"chongpai"] forState:UIControlStateNormal];
                    //右图左字
                    [retakeButtons setTitleEdgeInsets:UIEdgeInsetsMake(0, -retakeButtons.imageView.bounds.size.width, 0, retakeButtons.imageView.bounds.size.width)];
                    retakeButtons.imageEdgeInsets = UIEdgeInsetsMake(0, retakeButtons.titleLabel.bounds.size.width, 0, -retakeButtons.titleLabel.bounds.size.width);

                    [retakeButtons setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//                    [retakeButtons addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//                    [retakeButtons setTitle:@"Xs" forState:UIControlStateNormal];

                    [used setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [used setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
                    used.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 16);
                    used.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -16);
                    
                }
                if ( [[[tmpView2 class]description]isEqualToString:@"CAMBottomBar"])
                {

                    retakeButton = (UIButton *)[tmpView2.subviews lastObject];
                    [retakeButton addTarget:self action:@selector(takePhotoAgain) forControlEvents:UIControlEventTouchUpInside];
                    //获取到拍照界面的按钮
                    shutButton = (UIButton *)tmpView2.subviews[1];
                    [shutButton removeFromSuperview];
                }
                
                if ([[[tmpView2 class]description]isEqualToString:@"CAMTopBar"]) {
                    UIToolbar *topBar = (UIToolbar *)tmpView2;
                    [topBar removeFromSuperview];
                }

            }
        }
    }
    else{
        //在相机界面中进行循环遍历出shutterButton
        for (UIView *tmpView in viewController.view.subviews) {
            //隐藏拍照界面顶部的工具条
            if ([[[tmpView class]description]isEqualToString:@"CAMTopBar"]) {
                UIToolbar *topBar = (UIToolbar *)tmpView;
                [topBar removeFromSuperview];
            }
            //获取到重拍按钮
            for (UIView *tmpView2 in tmpView.subviews) {

                if ( [[[tmpView2 class]description]isEqualToString:@"PLCropOverlayBottomBar"])
                {
                    for (UIView *tmpView3 in tmpView2.subviews) {
                        retakeButton = (UIButton *)tmpView3.subviews[0];

                        [retakeButton addTarget:self action:@selector(takePhotoAgain) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                //获取到拍照界面的按钮
                if ( [[[tmpView2 class]description]isEqualToString:@"CAMShutterButton"]) {
                    shutButton = (UIButton *)tmpView2;
                    [shutButton setHidden:YES];
                    [shutButton addTarget:self action:@selector(setHiddenLabel) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}
//-(void)test{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
-(void)setHiddenLabel
{
    
}
-(void)takePhotoAgain
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)backAction:(UIBarButtonItem *)item
{
    //    WCLLog(@"你点击了我");
//    [photoCollection removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    [photoTable removeFromSuperview];
    photoTable = nil;
    photoModelArray = nil;
    
}
-(void)createPhotoTable
{
    photoTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-74:SCREEN_HEIGHT - 64)];
    photoTable.dataSource = self;
    photoTable.delegate = self;
    
    [photoTable registerClass:[photoTableViewCell class] forCellReuseIdentifier:@"photo"];
    [self.view addSubview:photoTable];
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, 20, 180, 40)];
    [button addTarget:self action:@selector(handOn) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setBackgroundColor:getUIColor(Color_buyColor)];
    [button.layer setCornerRadius:1];
    [button.layer setMasksToBounds:YES];
    [view addSubview:button];
    
    return view;
}
#pragma mark - 提交图片
-(void)handOn

{
    BiLi = nil;
//    CGFloat minArea = [self funMin:resultArray];
//    for (int i = 0; i < [resultArray count]; i ++) {
//        if ([resultArray[i] floatValue] - minArea > 15 || [resultArray[i] floatValue] - minArea < -15) {
//            [resultArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:minArea]];
//        }
//    }//62370
//    for (int j = 0; j < [resultArray count]; j ++) {
//
//        if ([[self deviceVersion] isEqualToString:@"X"]) {
//            [_params setObject:@"19.3305" forKey:@"actual_width"];
//            area = [resultArray[j] floatValue];
//            if (!BiLi) {
//                BiLi = [NSString stringWithFormat:@"%.4f",21.0  / area * 0.9205];
//            } else {
//                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area * 0.9205];
//            }
//        }
//        else if([[self deviceVersion]integerValue]==8)
//        {
//            [_params setObject:@"19.2058" forKey:@"actual_width"];
//            area = [resultArray[j] floatValue];
//            if (!BiLi) {
//                BiLi = [NSString stringWithFormat:@"%.4f",21.0  / area * 0.9183]; // 9183 9145
//            } else {
//                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area * 0.9183];
//            }
//
//        }else if ([[self deviceVersion] integerValue] == 7) {
//            [_params setObject:@"19.1415" forKey:@"actual_width"];
//            area = [resultArray[j] floatValue];
//            if (!BiLi) {
//                BiLi = [NSString stringWithFormat:@"%.4f",21.0  / area * 0.9115];//-0.88532
//            } else {
//                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area * 0.9115];
//            }
//
//        } else if ([[self deviceVersion] integerValue] == 6) {
//            area = [resultArray[j] floatValue];
//            CGFloat TSScan = 1.0;
//            if ([[self deviceVersion] isEqualToString:@"6"]) {
//                [_params setObject:@"18.7656" forKey:@"actual_width"];
//                TSScan = 0.8936;
//            } else if ([[self deviceVersion] isEqualToString:@"6P"]) {
//                TSScan = 0.9013;//-0.012
//                [_params setObject:@"18.9273" forKey:@"actual_width"];//62370
//            } else if([[self deviceVersion] isEqualToString:@"6S"] ||[[self deviceVersion] isEqualToString:@"6SP"]) {
//                TSScan = 0.8967;
//                [_params setObject:@"18.8307" forKey:@"actual_width"];
//            }
//
//            if (!BiLi) {
//                BiLi = [NSString stringWithFormat:@"%.4f",21  / area * TSScan];
//            } else {
//
//                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area *TSScan];
//
//            }
//        }
//    }
    
//    if ([[self deviceVersion] integerValue] == 7) {
//        [_params setObject:@"0.9673" forKey:@"type_scale"];
//    } else if([[self deviceVersion] integerValue] == 6) {
//        [_params setObject:@"0.9434" forKey:@"type_scale"];
//    }
//    else if ([[self deviceVersion]integerValue]==8)
//    {
//        [_params setObject:@"0.9912" forKey:@"type_scale"];
//    }
    [_params setObject:[SelfPersonInfo getInstance].personPhone forKey:@"phone"];
    [_params setObject:@"1,1,1,1" forKey:@"scale"];
//    [_params setObject:y_position forKey:@"y_position"];
    [_params setObject:[self deviceVersion] forKey:@"phone_type"];
    [self progressShow:@"上传中" animated:YES];
    
    [HttpRequestTool uploadMostImageWithURLString:[NSString stringWithFormat:@"%@%@", URL_HEADURL,URL_PHOTOTAKETEST] parameters:_params uploadDatas:photoDataArray success:^{
        [self progressHide:YES];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"数据传输成功！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"quickuploadsucess" object:nil userInfo:@{@"isopencv":@"2"}];
            [photoTable removeFromSuperview];
            photoTable = nil;
            [photoDataArray removeAllObjects];
            photoModelArray = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(NSError *) {
        [self progressHide:YES];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"通知"
                                                                       message:@"数据上传失败，请重新点击上传按钮，请保证网络畅通！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"quickuploadsucess" object:nil userInfo:@{@"isopencv":@"1"}];

                                                              }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 286;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [photoModelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    photoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    photoModel* model =photoModelArray[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [photoCollection reloadData];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    [photoCollection setContentOffset:CGPointMake(SCREEN_WIDTH * indexPath.row, 0)];
//    [photoCollection setAlpha:1];
//    [UIView commitAnimations];
}
//photo edit

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
