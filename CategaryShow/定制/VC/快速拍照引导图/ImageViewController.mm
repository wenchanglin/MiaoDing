//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import "ViewUtils.h"
#import "UIImage+Crop.h"
#import "UIImage+FixOrientation.h"
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
@interface ImageViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@end

@implementation ImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    NSString *info = [NSString stringWithFormat:@"Size: %@  -  Orientation: %ld", NSStringFromCGSize(self.image.size), (long)self.image.imageOrientation];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.infoLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    self.infoLabel.textColor = [UIColor whiteColor];
    self.infoLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = info;
    [self.view addSubview:self.infoLabel];
     UIImage * saflk =[self imageHog:_image];
    if (saflk==nil) {
        _image = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    }
    else
    {
        WCLLog(@"%@",saflk);
    }
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    [self.view addGestureRecognizer:tapGesture];

}
-(UIImage *)imageHog :(UIImage *)image{
    
    
    cv::Mat src;
    UIImageToMat(image, src);
    //首先把图片格式转换为CV_8UC3 否则报错：
    //Assertion failed (img.type() == CV_8U || img.type() == CV_8UC3) in computeGradient    // 8 bits per component, 3 channels
    cv::Mat rgbMat(image.size.width, image.size.height, CV_8UC3);
    cvtColor(src, rgbMat, CV_RGBA2RGB, 3);//CV_GRAY2RGB
    
    cv::HOGDescriptor hog;//HOG特征检测器
    hog.setSVMDetector(cv::HOGDescriptor::getDefaultPeopleDetector());//设置SVM分类器为默认参数
    std::vector<cv::Rect> found, found_filtered;//矩形框数组
    hog.detectMultiScale(rgbMat, found, 0, cv::Size(4,4), cv::Size(8,8), 1.20, 1);//默认1.05 改1.5
    //对图像进行多尺度检测，检测窗口移动步长为(8,8)
    //    IplImage *psrc = [self CreateIplImageFromUIImage:image];
    //    IplImage *pdst = NULL;
    //    WCLLog( @"矩形个数：%lu",found.size());
    CGFloat A =0;
    // 在每个人 画一个红色四方形
    for(unsigned int i= 0;i < found.size();i++)    {
        cv::Rect& face = found[i];//const
        cv::Point tl(face.x + 20,face.y + 50);
        cv::Point br = tl + cv::Point(face.width - 40,face.height - 100);        // 四方形的画法  框会比人大很多，不过在相同的距离拍摄的照片 框基本比人体大的部分为定值，所以调整参数的话，基本就能实现 框出人物头顶到脚底
        //        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        //        cv::rectangle(rgbMat, tl, br, magenta, 4, 8, 0);
        //        WCLLog(@"%d",face.height);
        A =  [self minBetweenA:A B:face.height];//  height 2430
        //        WCLLog(@"%f",A);
    }
    CGFloat dest = 1.0332;
    CGFloat h =(dest * _bodyHeight*image.size.height)/A;
    //    WCLLog(@"%f",h);// 3 》7 2<9
    if(250<h&&h<360)
    {
        return MatToUIImage(rgbMat);
    }
    
    else
    {
//        [self alertViewShowOfTime:@"请保持3米左右的距离拍摄" time:1];
       
        return nil;
    }
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    UIImage* imgTake = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    UIImage *imageFix = [self fixOrientation:imgTake];
//    UIImage *imageNew = [self scaleToSize:imageFix size:CGSizeMake(imageFix.size.width/2,imageFix.size.height/2)];
//    UIImage * resultImage = imageNew;
//    //    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//    //    PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:resultImage];
//    //                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//    //                        WCLLog(@"success = %d ,error =%@",success,error);
//    //                    }];
//    
//    //    WCLLog(@"x:%f--y:%f",resImg.size.width,resImg.size.height);
//    UIImage *resImg;
//    photoModel *model = photoModelArray[currentStep - 1];
//    if (currentStep>1&&currentStep<=4) {
//        model.photo = imageFix;
//    }
//    else if (currentStep==1)
//    {
//        resImg = [self imageHog:resultImage];
//        if (resImg==nil) {
//            [imagePickerController dismissViewControllerAnimated:NO completion:nil];
//            [self retake];
//            [shutMInebutton removeFromSuperview];
//        }
//        else
//        {
//            model.photo = resImg;
//        }
//    }
//    if (imageFix == nil) {//4032
//        //        [self alertViewShowOfTime:@"请保持3米左右的距离拍摄" time:1];
//        [imagePickerController dismissViewControllerAnimated:NO completion:nil];
//        if (currentStep <= 4) {
//            imagePickerController = [[UIImagePickerController alloc] init];
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePickerController.delegate   = self;
//            imagePickerController.allowsEditing = NO;
//            imagePickerController.cameraDevice  = UIImagePickerControllerCameraDeviceRear;
//            backgroundView = [[UIImageView alloc] initWithImage:backgroundImages[currentStep - 1]];;
//            [backgroundView setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height)];
//            [imagePickerController.view addSubview:backgroundView];
//            shutMInebutton = [[UIButton alloc] initWithFrame:CGRectMake(imagePickerController.view.frame.size.width / 2 - 30, imagePickerController.view.frame.size.height - 80, 60, 60)];
//            [shutMInebutton.layer setCornerRadius:30];
//            [shutMInebutton.layer setMasksToBounds:YES];
//            
//            [shutMInebutton setImage:[UIImage imageNamed:@"Noshutten"] forState:UIControlStateNormal];
//            [shutMInebutton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
//            [imagePickerController.view addSubview:shutMInebutton];
//            
//            
//            CGFloat H = 29.0 / 3000.0 * _bodyHeight / 0.81;
//            
//            UIView *lindDown = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint, 180, 1)];
//            [lindDown setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lindDown];
//            
//            
//            UIView *lindUp = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 180, 1)];
//            [lindUp setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lindUp];
//            
//            
//            UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
//            [lineLeft setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lineLeft];
//            
//            UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 89, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
//            [lineRight setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lineRight];
//            UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
//            [centerLine setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:centerLine];
//            //[backgroundView setFrame:imagePickerController.view.frame];
//            //imagePickerController.cameraOverlayView = backgroundView;
//            [self createCoreMotionOnCameraView];
//            __weak typeof(self) weakself = self;
//            [self presentViewController:imagePickerController animated:YES completion:^{
//                [weakself createMoveLabelWithTheGravityInCaremaView];
//            }];
//        }
//        else{
//            
//            [photoTable reloadData];
//        }
//    } else {
//        
//        NSData *imgData = UIImageJPEGRepresentation(imageFix, 1);
//        
//        NSString * base64 = [imgData base64EncodedStringWithOptions:kNilOptions];
//        [photoDataArray addObject:imgData];
//        if (stringImage) {
//            stringImage = [NSString stringWithFormat:@"%@,%@", stringImage, base64];
//        } else {
//            stringImage = base64;
//        }
//        
//        
//        [imagePickerController dismissViewControllerAnimated:NO completion:nil];
//        
//        if (currentStep < 4) {
//            
//            imagePickerController = [[UIImagePickerController alloc] init];
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            imagePickerController.delegate   = self;
//            imagePickerController.allowsEditing = NO;
//            imagePickerController.cameraDevice  = UIImagePickerControllerCameraDeviceRear;
//            
//            
//            currentStep++;
//            backgroundView = [[UIImageView alloc] initWithImage:backgroundImages[currentStep - 1]];;
//            [backgroundView setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height)];
//            [imagePickerController.view addSubview:backgroundView];
//            
//            shutMInebutton = [[UIButton alloc] initWithFrame:CGRectMake(imagePickerController.view.frame.size.width / 2 - 30, imagePickerController.view.frame.size.height - 80, 60, 60)];
//            [shutMInebutton.layer setCornerRadius:30];
//            [shutMInebutton.layer setMasksToBounds:YES];
//            [shutMInebutton setImage:[UIImage imageNamed:@"Noshutten"] forState:UIControlStateNormal];
//            [shutMInebutton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
//            [imagePickerController.view addSubview:shutMInebutton];
//            
//            
//            
//            CGFloat H = 29.0 / 3000.0 * _bodyHeight/ 0.81;
//            UIView *lindDown = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint, 180, 1)];
//            [lindDown setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lindDown];
//            
//            
//            UIView *lindUp = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 180, 1)];
//            [lindUp setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lindUp];
//            UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
//            [lineLeft setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lineLeft];
//            
//            UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 89, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
//            [lineRight setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:lineRight];
//            
//            UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, imagePickerController.view.frame.size.height - lowPoint - (H *0.3937 * ppi), 1, (H *0.3937 * ppi))];
//            [centerLine setBackgroundColor:[UIColor whiteColor]];
//            [imagePickerController.view addSubview:centerLine];
//            
//            [self createCoreMotionOnCameraView];
//            [self presentViewController:imagePickerController animated:YES completion:^{
//                [self createMoveLabelWithTheGravityInCaremaView];
//            }];
//        }
//        else{
//            
//            [photoTable reloadData];
//        }
//    }
//}
-(CGFloat)minBetweenA:(CGFloat)a B:(CGFloat)b
{
    if (a < b) {
        return b;
    } else return a;
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
