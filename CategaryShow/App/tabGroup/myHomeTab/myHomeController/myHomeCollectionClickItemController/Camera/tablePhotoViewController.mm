 //
//  tablePhotoViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#import "sys/utsname.h"
#import "tablePhotoViewController.h"
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
#define LabelX backgroundView.center.x / 16 - 7.5
#define LeftLabelY  backgroundView.center.y
#define DownLabelX  backgroundView.center.x
#define DownLabelY  LeftLabelY * 1.66 - 5
using namespace cv;
using namespace std;
Mat img;
Mat templ;
Mat result;
Mat drawing;
NSMutableArray *areaArray;
NSMutableArray *resultArray;
NSMutableArray *pisitonArray;
CGFloat ppi;
UIImageView *imagev;
BOOL canShut;
int match_method;
int max_Trackbar = 5;
CGFloat lowPoint;

int thresh = 100;
int max_thresh = 255;
RNG rng(12345);

CGPoint pointSize;

NSInteger flog;

@interface tablePhotoViewController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong) UILabel *leftLabel;

@end

@implementation tablePhotoViewController
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
    
    UIButton *helpBtn;
    UIView *cameraResult;
    UISwitch *chooseSwitch;
    NSMutableArray * iphone7Arr;
    NSMutableArray *photoDataArray;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"拍照结果"];
    areaArray = [NSMutableArray array];
    resultArray = [NSMutableArray array];
    UIBarButtonItem *item =   [[UIBarButtonItem alloc]initWithImage:[self reSizeImage:[UIImage imageNamed:@"backLeftWhite"] toSize:CGSizeMake(9, 16)] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = item;
    
    ppi = [self getPPi];
    canShut = NO;
    y_position = NULL;
    iphone7Arr = [NSMutableArray array];
    photoDataArray = [NSMutableArray array];
    postData = [BaseDomain getInstance:NO];
    pisitonArray = [NSMutableArray array];
    photoModelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"重拍" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self createPhotoShow];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
-(void)backAction:(UIBarButtonItem *)item
{
//    WCLLog(@"你点击了我");
    [photoCollection removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    [photoTable removeFromSuperview];
    photoTable = nil;
    photoModelArray = nil;
    photoCollection =nil;

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
    [resultArray removeAllObjects];
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
    
   
    
    //[backgroundView setFrame:imagePickerController.view.frame];
    //    imagePickerController.cameraOverlayView = backgroundView;
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
    UIImage *resImg = [self imageHog:imageFix];
//    UIImageWriteToSavedPhotosAlbum(resImg, self, @selector(image:didFinishSavingWithError:contextInfo:), self);
  
    if (resImg == nil) {
        [imagePickerController dismissViewControllerAnimated:NO completion:nil];
        
        if (currentStep <= 4) {
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate   = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.cameraDevice  = UIImagePickerControllerCameraDeviceRear;
            backgroundView = [[UIImageView alloc] initWithImage:backgroundImages[currentStep - 1]];
            [backgroundView setFrame:CGRectMake(0, 0, imagePickerController.view.frame.size.width, imagePickerController.view.frame.size.height)];
            [imagePickerController.view addSubview:backgroundView];
            shutMInebutton = [[UIButton alloc] initWithFrame:CGRectMake(imagePickerController.view.frame.size.width / 2 - 30, imagePickerController.view.frame.size.height - 80, 60, 60)];
            [shutMInebutton.layer setCornerRadius:30];
            [shutMInebutton.layer setMasksToBounds:YES];
//            shutMInebutton.backgroundColor = [UIColor colorWithHexString:@"#999999"];
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
        
       
        
        
        NSData *imgData = UIImageJPEGRepresentation(resImg, 1);
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
//            shutMInebutton.backgroundColor = [UIColor colorWithHexString:@"#999999"];
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
            
            //[backgroundView setFrame:imagePickerController.view.frame];
            //imagePickerController.cameraOverlayView = backgroundView;
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



//-(CGFloat)max:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
//{
//    CGFloat re;
//    if (r > g && r > b) {
//        re = r;
//    } else if (g > r && g > b) {
//        re = g;
//    } else if (b > r && b > g) {
//        re = b;
//    }
//    return  re;
//}
//
//-(CGFloat)min:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
//{
//    CGFloat re;
//    if (r < g && r < b) {
//        re = r;
//    } else if (g < r && g < b) {
//        re = g;
//    } else if (b < r && b < g) {
//        re = b;
//    }
//    return  re;
//}



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


-(UIImage *)imageHog :(UIImage *)image{
    UIImage *reImg;
   
        
    CGFloat H = 29.0 / 3000.0 * _bodyHeight/ 0.81;
    
    CGFloat downScan = (lowPoint - 180 ) / (SCREEN_HEIGHT - 180 - 40);
    CGFloat heightScan = (H *0.3937 * ppi) / (SCREEN_HEIGHT - 180 - 40);
    CGFloat widthScan = 180.0 / SCREEN_WIDTH;
    
    IplImage *psrc = [self CreateIplImageFromUIImage:image];
    IplImage *pdst;
    
    CvSize size = cvSize(image.size.width * widthScan+100, image.size.height *  heightScan + 600);
    cvSetImageROI(psrc, cvRect((image.size.width  / 2)- (size.width / 2), image.size.height - (image.size.height * downScan) - size.height, size.width, size.height));
    pdst = cvCreateImage(size, psrc ->depth, psrc ->nChannels);
    cvCopy(psrc,pdst);
    reImg = [self convertToUIImage:pdst];
    cvReleaseImage(&psrc);
    cvReleaseImage(&pdst);

   CGFloat re = [self showImage:reImg];
    
    
   if (re == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"距离太近了或没有检测到参照物，请保证拍照者与墙的距离不小于2.5米；没有强烈光照；参照物与墙的颜色不相同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
//         [progressHud hideAnimated:YES];
        return nil;
   } else if (re == 1) {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"距离太远了哦亲~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
       [alert show];
       //         [progressHud hideAnimated:YES];
       return nil;
   } else if(re == 2) {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"距离太近了哦亲~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
       [alert show];
       return nil;
   }
//     [progressHud hideAnimated:YES];
    
    [pisitonArray removeAllObjects];
    [areaArray removeAllObjects];
    return reImg;
    
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
//                            shutMInebutton.backgroundColor = [UIColor colorWithHexString:@"#90c551"];
                            [shutMInebutton setImage:[UIImage imageNamed:@"shutten"] forState:UIControlStateNormal];
                        } else {
                            canShut = NO;
//                            shutMInebutton.backgroundColor = [UIColor colorWithHexString:@"#999999"];
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
         //   NSLog(@"2:   %@", tmpView.subviews);
            
            //删除拍照界面顶部的工具条 (iOS9之后设置topBar隐藏属性是不能够隐藏掉那个前置摄像头)
            
            //获取重拍按钮
            for (UIView *tmpView2 in tmpView.subviews) {
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
                    //                    [shutButton removeFromSuperview];
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

-(void)takePhotoAgain
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setHiddenLabel
{
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createPhotoShow
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    photoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT  - 64) collectionViewLayout:flowLayout];
    
    //设置代理
    photoCollection.delegate = self;
    photoCollection.dataSource = self;
    [photoCollection setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:photoCollection];
    
    [photoCollection setAlpha:0];
    photoCollection.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    photoCollection.pagingEnabled = YES ;
    [photoCollection registerClass:[takePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [photoCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [photoModelArray count];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *reCell;
    static NSString *identify = @"cell";
    takePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.model =photoModelArray[indexPath.item];
    [cell sizeToFit];
    reCell = cell;
    return reCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [photoCollection setAlpha:0];
    [UIView commitAnimations];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 );
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
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
    CGFloat minArea = [self funMin:resultArray];
    for (int i = 0; i < [resultArray count]; i ++) {
        if ([resultArray[i] floatValue] - minArea > 15 || [resultArray[i] floatValue] - minArea < -15) {
            [resultArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:minArea]];
        }
    }//62370
    for (int j = 0; j < [resultArray count]; j ++) {
        
        if ([[self deviceVersion] isEqualToString:@"X"]) {
            [_params setObject:@"19.3305" forKey:@"actual_width"];
            area = [resultArray[j] floatValue];
            if (!BiLi) {
                BiLi = [NSString stringWithFormat:@"%.4f",21.0  / area * 0.9205];
            } else {
                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area * 0.9205];
            }
        }
        else if([[self deviceVersion]integerValue]==8)
        {
            [_params setObject:@"19.2058" forKey:@"actual_width"];
            area = [resultArray[j] floatValue];
            if (!BiLi) {
                BiLi = [NSString stringWithFormat:@"%.4f",21.0  / area * 0.9183]; // 9183 9145
            } else {
                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area * 0.9183];
            }
            
        }else if ([[self deviceVersion] integerValue] == 7) {
            [_params setObject:@"19.1415" forKey:@"actual_width"];
            area = [resultArray[j] floatValue];
            if (!BiLi) {
                BiLi = [NSString stringWithFormat:@"%.4f",21.0  / area * 0.9115];//-0.88532
            } else {
                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area * 0.9115];
            }
            
        } else if ([[self deviceVersion] integerValue] == 6) {
            area = [resultArray[j] floatValue];
            CGFloat TSScan = 1.0;
            if ([[self deviceVersion] isEqualToString:@"6"]) {
                [_params setObject:@"18.7656" forKey:@"actual_width"];
                TSScan = 0.8936;
            } else if ([[self deviceVersion] isEqualToString:@"6P"]) {
                TSScan = 0.9013;//-0.012
                 [_params setObject:@"18.9273" forKey:@"actual_width"];//62370
            } else if([[self deviceVersion] isEqualToString:@"6S"] ||[[self deviceVersion] isEqualToString:@"6SP"]) {
                TSScan = 0.8967;
                [_params setObject:@"18.8307" forKey:@"actual_width"];
            }
            
            if (!BiLi) {
                BiLi = [NSString stringWithFormat:@"%.4f",21  / area * TSScan];
            } else {
                
                BiLi = [NSString stringWithFormat:@"%@,%.4f",BiLi,21  / area *TSScan];
                
                }
            }
    }
    
    if ([[self deviceVersion] integerValue] == 7) {
        [_params setObject:@"0.9673" forKey:@"type_scale"];
    } else if([[self deviceVersion] integerValue] == 6) {
        [_params setObject:@"0.9434" forKey:@"type_scale"];
    }
    else if ([[self deviceVersion]integerValue]==8)
    {
        [_params setObject:@"0.9912" forKey:@"type_scale"];
    }
    [_params setObject:[SelfPersonInfo getInstance].personPhone forKey:@"phone"];
    [_params setObject:BiLi forKey:@"scale"];
    [_params setObject:y_position forKey:@"y_position"];
    [_params setObject:[self deviceVersion] forKey:@"phone_type"];
    [self progressShow:@"上传中" animated:YES];
    
    [HttpRequestTool uploadMostImageWithURLString:[NSString stringWithFormat:@"%@%@", URL_HEADURL,URL_PHOTOTAKETEST] parameters:_params uploadDatas:photoDataArray success:^{
        [self progressHide:YES];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"数据传输成功！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
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
        
                                                                      }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            
    }];
    
//    [postData postData:URL_PHOTOTAKE PostParams:_params finish:^(BaseDomain *domain, Boolean success) {
//    [self progressHide:YES];
//    if ([[domain.dataRoot stringForKey:@"code"] integerValue] == 1) {
//        
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"通知"
//                                                                           message:@"数据传输成功！"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {
//                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
//                                                                  }];
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
//    } else {
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"通知"
//                                                                       message:@"数据成功失败，请重新点击上传按钮，请保证网络畅通！"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {
//                                                                 
//                                                              }];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//        
//    }];
    
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
    [photoCollection reloadData];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [photoCollection setContentOffset:CGPointMake(SCREEN_WIDTH * indexPath.row, 0)];
    [photoCollection setAlpha:1];
    [UIView commitAnimations];
}
 //photo edit


-(int)cvThresholdOtsu:(IplImage*)src
{
    int height=src->height;
    int width=src->width;
    
    //histogram
    float histogram[256]={0};
    for(int i=0;i<height;i++) {
        unsigned char* p=(unsigned char*)src->imageData+src->widthStep*i;
        for(int j=0;j<width;j++) {
            histogram[*p++]++;
        }
    }
    //normalize histogram
    int size=height*width;
    for(int i=0;i<256;i++) {
        histogram[i]=histogram[i]/size;
    }
    
    //average pixel value
    float avgValue=0;
    for(int i=0;i<256;i++) {
        avgValue+=i*histogram[i];
    }
    
    int threshold = 0;
    float maxVariance=0;
    float w=0,u=0;
    for(int i=0;i<256;i++) {
        w+=histogram[i];
        u+=i*histogram[i];
        
        float t=avgValue*w-u;
        float variance=t*t/(w*(1-w));
        if(variance>maxVariance) {
            maxVariance=variance;
            threshold=i;
        }
    }
    
    return threshold;
}

-(void)chage:(UITapGestureRecognizer *)tap
{
    if (flog == 0) {
        flog = 1;
        [imagev setImage:[self MatToUIImage:drawing]];
    } else {
        [imagev setHidden:YES];
    }
    
}

-(CGFloat) funMin:(NSMutableArray *)array
{
    CGFloat min;
    min = [array[0] floatValue];
    for (int i=0;i<[array count];i++)
    {
        CGFloat x = [array[i] floatValue];
        
        if (min>x)
        {
            min=x;
        }
    }
    return min;
}

#pragma mark - 显示图片
-(CGFloat)showImage:(UIImage *)imageTemp
{
    
    
    IplImage *psrc = [self CreateIplImageFromUIImage:imageTemp];
    IplImage *pdst;
    CvSize size = cvSize(imageTemp.size.width , imageTemp.size.height); ///2);
    cvSetImageROI(psrc, cvRect(0,0, size.width, size.height));
    pdst = cvCreateImage(size, psrc ->depth, psrc ->nChannels);
    cvCopy(psrc,pdst);
    UIImage * image = [self convertToUIImage:pdst];
    cvReleaseImage(&psrc);
    cvReleaseImage(&pdst);


    if ([[self deviceVersion] integerValue] == 6) {
        area = 0.0000;
        Mat temp1;
        Mat dst;
        UIImageToMat(image, temp1);
        Mat gray_temp;
        GaussianBlur(temp1, temp1, cv::Size(3,3), 15);
        cvtColor(temp1,gray_temp,CV_BGR2GRAY);
        equalizeHist(gray_temp, dst);

        adaptiveThreshold(gray_temp, img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 5, -1);
        
        vector<vector<cv::Point>>contours1;
        vector<Vec4i> hierarchy;
        drawing = Mat::zeros( img.size(), CV_8UC3 );
        //        [imagev removeFromSuperview];
        //        flog=0;
        //        imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //        [imagev setUserInteractionEnabled:YES];
        //        [imagev setImage:[self MatToUIImage:img]];
        //        [imagev setContentMode:UIViewContentModeScaleAspectFill];
        //        [self.view addSubview:imagev];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chage:)];
        //        [imagev addGestureRecognizer:tap];

        findContours( img, contours1, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
        Mat result1(img.size(), CV_8U, cv::Scalar(255));
        vector<RotatedRect> minRect( contours1.size() );
        for (unsigned int i = 0; i < contours1.size(); i ++) {
            minRect[i] = minAreaRect(contours1[i]);
            CGFloat x = minRect[i].size.width * minRect[i].size.height;
            CGFloat y = minRect[i].size.width / minRect[i].size.height;
            if (x > 30000 ) {
                Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
                Point2f rect_points[4]; minRect[i].points( rect_points );
                for( int j = 0; j < 4; j++ )
                    line( drawing, rect_points[j], rect_points[(j+1)%4], color, 1, 8 );
            }
            if ([[self deviceVersion] isEqualToString:@"6"] || [[self deviceVersion] isEqualToString:@"6P"]) {
                if ((y > 1.38 && y < 1.44) || (y > 0.694 && y < 0.7246)) {
                    if (x > 40000 && x < 70000) {
//                        WCLLog(@"%f",x);
                        
                        CGFloat reMin = [self minBetweenA:minRect[i].size.height B:minRect[i].size.width];
                       // WCLLog(@"x面积:%f-----%f---A:%f---B:%f", x,reMin,minRect[i].size.height,minRect[i].size.width);

                        [pisitonArray addObject:[NSNumber numberWithFloat:minRect[i].center.y]];
                        [areaArray addObject:[NSNumber numberWithFloat:reMin]];
                    } else if(x < 40000){
                         area = 1;
                    } else if (x > 70000) {
                        area = 2;
                    }
                }else {
                    area = 0;
                }
                

            } else { //6s 6s plus

                if ((y > 1.38 && y < 1.44) || (y > 0.694 && y < 0.7246)) {
                    if (x > 65000 && x < 106000) {
//                        WCLLog(@"%f",x);
                        CGFloat reMin = [self minBetweenA:minRect[i].size.height B:minRect[i].size.width];
                        [pisitonArray addObject:[NSNumber numberWithFloat:minRect[i].center.y]];
                        [areaArray addObject:[NSNumber numberWithFloat:reMin]];
                    } else if(x < 65000 ){
                        area = 1;
                    } else if (x > 106000) {
                        area = 2;
                    }
                } else {
                    area = 0;
                }
                
                

            }
            
        }
        
        if ([areaArray count] > 1) {
            area = [self funMin:areaArray];
            
            for (int i = 0; i < [areaArray count]; i ++) {
                if (area == [areaArray[i] floatValue]) {
                    if (y_position) {
                        y_position = [NSString stringWithFormat:@"%@,%f",y_position,[pisitonArray[i] floatValue]];
                    } else {
                        y_position = [NSString stringWithFormat:@"%f",[pisitonArray[i] floatValue]];
                    }
                }
            }
            
            [resultArray addObject:[NSNumber numberWithFloat:area]];
        }
        
        
        
        photoModel *model = photoModelArray[currentStep - 1];
        if (area > 2) {
            model.photo = [self MatToUIImage:img];
        }
//        WCLLog(@"%f", area);
        

    } else if ([[self deviceVersion] integerValue] == 7) {
        area = 0.0000;
        Mat temp1;
        Mat dst;
        UIImageToMat(image, temp1);
        Mat gray_temp;
        //        gaussblur(temp1, temp1, cv::Size(3,3));
        GaussianBlur(temp1, temp1, cv::Size(3,3), 7);
        cvtColor(temp1,gray_temp,CV_BGR2GRAY);
        //
        equalizeHist(gray_temp, dst);
        
        adaptiveThreshold(gray_temp, img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 7, -1);

//        adaptiveThreshold(gray_temp, img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 13, -1);//13

        vector<vector<cv::Point>>contours1;
        vector<Vec4i> hierarchy;
        drawing = Mat::zeros( img.size(), CV_8UC3 );
//        [imagev removeFromSuperview];
//        flog=0;
//        imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        [imagev setUserInteractionEnabled:YES];
//        [imagev setImage:[self MatToUIImage:img]];
//        [imagev setContentMode:UIViewContentModeScaleAspectFill];
//        [self.view addSubview:imagev];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chage:)];
//        [imagev addGestureRecognizer:tap];
        //
        findContours( img, contours1, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
        Mat result1(img.size(), CV_8U, cv::Scalar(255));
//无底图测量
        vector<RotatedRect> minRect( contours1.size() );
        for (unsigned int i = 0; i < contours1.size(); i ++) {
            minRect[i] = minAreaRect(contours1[i]);
            CGFloat x = minRect[i].size.width * minRect[i].size.height;
            CGFloat y = minRect[i].size.width / minRect[i].size.height;
//            NSLog(@"area :%f", x);
            if (x > 30000 && x < 110000) {
                Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
                Point2f rect_points[4]; minRect[i].points( rect_points );
                for( int j = 0; j < 4; j++ )
                    line( drawing, rect_points[j], rect_points[(j+1)%4], color, 1, 8 );
            }
//            [iphone7Arr removeAllObjects];

            if ((y > 1.38 && y < 1.44) || (y > 0.694 && y < 0.7246)) {
                if (x > 60000 && x < 94000) {
            //        WCLLog(@"%f", x);
//                    [iphone7Arr addObject:@(x)];
                    CGFloat reMin = [self minBetweenA:minRect[i].size.height B:minRect[i].size.width];
            //        WCLLog(@"x面积:%f-----%f---A:%f---B:%f", x,reMin,minRect[i].size.height,minRect[i].size.width);
                   // [self alertViewShowOfTime:[NSString stringWithFormat:@"%f",sqrt(62370/x)] time:1];
            //        WCLLog(@"%f",sqrt(62370/x));//210*297
                    [pisitonArray addObject:[NSNumber numberWithFloat:minRect[i].center.y]];
                    [areaArray addObject:[NSNumber numberWithFloat:reMin]];
                } else if(x < 60000){
                    area = 1;
                } else if (x > 94000) {
                    area = 2;
                }
            }else {
                area = 0;
            }
            
           
           
        }
        
        [self.view addSubview:imagev];
        
        if ([areaArray count] > 1) {
            area = [self funMin:areaArray];
            
            for (int i = 0; i < [areaArray count]; i ++) {
                if (area == [areaArray[i] floatValue]) {
                    if (y_position) {
                        y_position = [NSString stringWithFormat:@"%@,%f",y_position,[pisitonArray[i] floatValue]];
                    } else {
                        y_position = [NSString stringWithFormat:@"%f",[pisitonArray[i] floatValue]];
                    }
                }
            }
            [resultArray addObject:[NSNumber numberWithFloat:area]];
            WCLLog(@"%f",21/area);
        }
        
        
        photoModel *model = photoModelArray[currentStep - 1];
        if (area > 2) {
            model.photo = [self MatToUIImage:img];
//            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:model.photo];
//            } completionHandler:^(BOOL success, NSError * _Nullable error) {
//                WCLLog(@"success = %d ,error =%@",success,error);
//            }];
        }


    }
    else if ([[self deviceVersion] integerValue] == 8) {
        
        
        area = 0.0000;
        Mat temp1;
        Mat dst;
        UIImageToMat(image, temp1);
        Mat gray_temp;
        //        gaussblur(temp1, temp1, cv::Size(3,3));
        GaussianBlur(temp1, temp1, cv::Size(3,3), 7);
        cvtColor(temp1,gray_temp,CV_BGR2GRAY);
        //
        equalizeHist(gray_temp, dst);
        
        
        adaptiveThreshold(gray_temp, img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 5, -1);//13
        
        vector<vector<cv::Point>>contours1;
        vector<Vec4i> hierarchy;
        drawing = Mat::zeros( img.size(), CV_8UC3 );
        findContours( img, contours1, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
        Mat result1(img.size(), CV_8U, cv::Scalar(255));
        //无底图测量
        vector<RotatedRect> minRect( contours1.size() );
        
        for (unsigned int i = 0; i < contours1.size(); i ++) {
            minRect[i] = minAreaRect(contours1[i]);
            CGFloat x = minRect[i].size.width * minRect[i].size.height;
            CGFloat y = minRect[i].size.width / minRect[i].size.height;
            if(x>30000&&x<110000)
            {
               
                Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
                Point2f rect_points[4]; minRect[i].points( rect_points );
                for( int j = 0; j < 4; j++ )
                    line( drawing, rect_points[j], rect_points[(j+1)%4], color, 1, 8 );
            }

            if ((y > 1.38 && y < 1.44) || (y > 0.694 && y < 0.7246)) {

                if (x > 60000 && x < 94000) {
                    CGFloat reMin = [self minBetweenA:minRect[i].size.height B:minRect[i].size.width];
                    WCLLog(@"x面积:%f-----%f---A:%f---B:%f", x,reMin,minRect[i].size.height,minRect[i].size.width);
                    
                    WCLLog(@"%f",sqrt(62370/x));//210*297 -0.03
                    [pisitonArray addObject:[NSNumber numberWithFloat:minRect[i].center.y]];
                    [areaArray addObject:[NSNumber numberWithFloat:reMin]];
                } else if(x < 60000){
                    area = 1;
                } else if (x > 94000) {
                    area = 2;
                }
            }else {
                area = 0;
            }
            
            
        }
        
        
        
        [self.view addSubview:imagev];
        
        if ([areaArray count] > 1) {
            area = [self funMin:areaArray];
            
            for (int i = 0; i < [areaArray count]; i ++) {
                if (area == [areaArray[i] floatValue]) {
                    if (y_position) {
                        y_position = [NSString stringWithFormat:@"%@,%f",y_position,[pisitonArray[i] floatValue]];
                    } else {
                        y_position = [NSString stringWithFormat:@"%f",[pisitonArray[i] floatValue]];
                    }
                }
            }
            WCLLog(@"%f",21/area);//155.465
            [resultArray addObject:[NSNumber numberWithFloat:area]];
            
        }
        
        
        photoModel *model = photoModelArray[currentStep - 1];
        if (area > 2) {
            model.photo = [self MatToUIImage:img];
        }
        
        
    }
    else if ([[self deviceVersion] isEqualToString:@"X"]) {
        
        area = 0.0000;
        Mat temp1;
        Mat dst;
        UIImageToMat(image, temp1);
        Mat gray_temp;
        //        gaussblur(temp1, temp1, cv::Size(3,3));
        GaussianBlur(temp1, temp1, cv::Size(3,3), 7);
        cvtColor(temp1,gray_temp,CV_BGR2GRAY);
        //
        equalizeHist(gray_temp, dst);
        
        
        adaptiveThreshold(gray_temp, img, 255, ADAPTIVE_THRESH_GAUSSIAN_C, CV_THRESH_BINARY, 5, -1);//13 -1
        
        vector<vector<cv::Point>>contours1;
        vector<Vec4i> hierarchy;
        drawing = Mat::zeros( img.size(), CV_8UC3 );
        findContours( img, contours1, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
        Mat result1(img.size(), CV_8U, cv::Scalar(255));
        //无底图测量
        vector<RotatedRect> minRect( contours1.size() );
        
        for (unsigned int i = 0; i < contours1.size(); i ++) {
            minRect[i] = minAreaRect(contours1[i]);
            CGFloat x = minRect[i].size.width * minRect[i].size.height;
            CGFloat y = minRect[i].size.width / minRect[i].size.height;
            if(x>30000&&x<110000)
            {
               // WCLLog(@"%f",x);

                Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
                Point2f rect_points[4]; minRect[i].points( rect_points );
                for( int j = 0; j < 4; j++ )
                    line( drawing, rect_points[j], rect_points[(j+1)%4], color, 1, 8 );
            }
//
            if ((y > 1.38 && y < 1.44) || (y > 0.694 && y < 0.7246)) {

                if (x > 60000 && x < 94000) {
                    CGFloat reMin = [self minBetweenA:minRect[i].size.height B:minRect[i].size.width];
                    WCLLog(@"x面积:%f-----%f---A:%f---B:%f", x,reMin,minRect[i].size.height,minRect[i].size.width);

                    WCLLog(@"%f",sqrt(62370/x));//210*297
                    [pisitonArray addObject:[NSNumber numberWithFloat:minRect[i].center.y]];
                    [areaArray addObject:[NSNumber numberWithFloat:reMin]];
                } else if(x < 60000){
                    area = 1;
                } else if (x > 94000) {
                    area = 2;
                }
            }else {
                area = 0;
            }
            
            
        }
        
        
        
        [self.view addSubview:imagev];
        
        if ([areaArray count] > 1) {
            area = [self funMin:areaArray];
            
            for (int i = 0; i < [areaArray count]; i ++) {
                if (area == [areaArray[i] floatValue]) {
                    if (y_position) {
                        y_position = [NSString stringWithFormat:@"%@,%f",y_position,[pisitonArray[i] floatValue]];
                    } else {
                        y_position = [NSString stringWithFormat:@"%f",[pisitonArray[i] floatValue]];
                    }
                }
            }
            WCLLog(@"%f",21/area);
            [resultArray addObject:[NSNumber numberWithFloat:area]];
            
        }
        
        
        photoModel *model = photoModelArray[currentStep - 1];
        if (area > 2) {
            model.photo = [self MatToUIImage:img];
        }
        
        
    }
    return area;

}


-(CGFloat)minBetweenA:(CGFloat)a B:(CGFloat)b
{
    if (a < b) {
        return a;
    } else return b;
}
-(CGFloat)a:(CGFloat)a xiaoyub:(CGFloat)b
{
    if(a<b)
    {
        return a/b;
    }else return b/a;
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


-(UIImage*)convertToUIImage:(IplImage*)image
{
    cvCvtColor(image, image, CV_BGR2RGB);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(image->width, image->height, image->depth, image->depth * image->nChannels, image->widthStep, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

-(Mat)MatchingMethod:(int)x y:(void*)y {
    Mat img_display;
    img.copyTo( img_display );

    /// 创建输出结果的矩阵
    int result_cols =  img.cols - templ.cols + 1;
    int result_rows = img.rows - templ.rows + 1;

    result.create( result_cols, result_rows, CV_32FC1 );

    /// 进行匹配和标准化
    matchTemplate( img, templ, result, CV_TM_SQDIFF_NORMED );
    normalize( result, result, 0, 1, NORM_MINMAX, -1, Mat() );

    /// 通过函数 minMaxLoc 定位最匹配的位置
    double minVal; double maxVal; cv::Point minLoc; cv::Point maxLoc;
    cv::Point matchLoc;

    minMaxLoc( result, &minVal, &maxVal, &minLoc, &maxLoc, Mat() );

    /// 对于方法 SQDIFF 和 SQDIFF_NORMED, 越小的数值代表更高的匹配结果. 而对于其他方法, 数值越大匹配越好

    matchLoc = minLoc;
    /// 让我看看您的最终结果
    rectangle( img_display, matchLoc, cv::Point( matchLoc.x + templ.cols , matchLoc.y + templ.rows ), Scalar::all(170), 2, 8, 0 );
    rectangle( result, matchLoc, cv::Point( matchLoc.x + templ.cols , matchLoc.y + templ.rows ), Scalar::all(170), 2, 8, 0 );

    pointSize = CGPointMake(matchLoc.x, matchLoc.y);

    //    imshow( image_window, img_display );
    //    imshow( result_window, result );
    
    
    return img_display;
}



-(void)UIImageToMat:(const UIImage*)image matM:(cv::Mat&)m alpha:(bool)alphaExist
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width, rows = image.size.height;
    CGContextRef contextRef;
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
    if (CGColorSpaceGetModel(colorSpace) == 0)
    {
        m.create(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
        bitmapInfo = kCGImageAlphaNone;
        if (!alphaExist)
            bitmapInfo = kCGImageAlphaNone;
        contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                           m.step[0], colorSpace,
                                           bitmapInfo);
    }
    else
    {
        m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
        if (!alphaExist)
            bitmapInfo = kCGImageAlphaNoneSkipLast |
            kCGBitmapByteOrderDefault;
        contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                           m.step[0], colorSpace,
                                           bitmapInfo);
    }
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows),
                       image.CGImage);
    CGContextRelease(contextRef);
}





- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    
    cvReleaseImage(&iplimage);
    return ret;
}

-(UIImage *) MatToUIImage:(const cv::Mat& )image{
    
    NSData *data = [NSData dataWithBytes:image.data
                                  length:image.elemSize()*image.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Preserve alpha transparency, if exists
    bool alpha = image.channels() == 4;
    CGBitmapInfo bitmapInfo = (alpha ? kCGImageAlphaLast : kCGImageAlphaNone) | kCGBitmapByteOrderDefault;
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(image.cols,
                                        image.rows,
                                        8,
                                        8 * image.elemSize(),
                                        image.step.p[0],
                                        colorSpace,
                                        bitmapInfo,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
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
