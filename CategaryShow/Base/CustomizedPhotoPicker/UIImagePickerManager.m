//
//  UIImagePickerManager.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/25.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "UIImagePickerManager.h"
#import "BlockActionSheet.h"
#import "AppDelegate.h"

static UIImagePickerManager * _imagePickerManager;

@interface UIImagePickerManager() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,copy) ImagePickerBlock imagePickerBlock;

@property (nonatomic,assign) CGSize cropSize;

@property (nonatomic,assign) Boolean allowsEditing;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

@end

@implementation UIImagePickerManager

+ (instancetype) getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_imagePickerManager == nil) {
            _imagePickerManager = [[UIImagePickerManager alloc] init];
        }
    });
    
    return _imagePickerManager;
}

- (void) show : (UIViewController *) viewController  allowsEditing:(Boolean) allowsEditing cropSize:(CGSize) cropSize finish:(ImagePickerBlock) success {
    
    self.imagePickerBlock = success;
    self.cropSize = cropSize;
    self.allowsEditing = allowsEditing;

    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"选择图片获取方式"];
    [sheet addButtonWithTitle:@"相机" block:^{
        [self showUIImagePick:viewController sourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    [sheet addButtonWithTitle:@"相册" block:^{
        [self showUIImagePick:viewController sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    
    [sheet showInView:viewController.view];
}

- (void) showUIImagePick :(UIViewController *) viewController sourceType: (UIImagePickerControllerSourceType) sourceType {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType = sourceType;
    
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if (!CGSizeEqualToSize(self.cropSize,CGSizeZero)) {
        
    }
    imagePickerController.allowsEditing = self.allowsEditing;
    
    imagePickerController.delegate = self;
    
    [viewController presentViewController:imagePickerController animated:YES completion:^{
//        [[AppDelegate getInstance].statusBarBackground setHidden:YES];
    }];
}

#pragma mark
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    UIImage *imageSource;
    
    if (self.allowsEditing) {
        imageSource = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        imageSource = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    UIImage * imageResult;
    
    if (!CGSizeEqualToSize(self.cropSize,CGSizeZero)){
        CGSize sizeCrop;
        
        if (self.cropSize.width > 0 && self.cropSize.height > 0) {
            
            sizeCrop = self.cropSize;
            
        }
        else {
            // 计算纵横比
            if (self.cropSize.width > 0) {
                sizeCrop.width = self.cropSize.width;
                
                sizeCrop.height = imageSource.size.height * (sizeCrop.width / imageSource.size.width);
            }
            else {
                sizeCrop.height = self.cropSize.height;
                
                sizeCrop.width = imageSource.size.width * (sizeCrop.height / imageSource.size.height);
            }
        }
        
        imageResult = [UIImagePickerManager imageWithImageSimple:imageSource scaledToSize:sizeCrop];
    }
    else {
        
        CGSize imagesize = imageSource.size;
        if (imageSource.size.width > imageSource.size.height) {
            imagesize.width = 1024;
            imagesize.height = imageSource.size.height / imageSource.size.width * 1024;
        } else {
            imagesize.height = 1024;
            imagesize.width = imageSource.size.width / imageSource.size.height * 1024;
        }
        imageResult = [UIImagePickerManager imageWithImageSimple:imageSource scaledToSize:imagesize];
        
        
    }
    
    if (self.imagePickerBlock) {
        self.imagePickerBlock(imageResult);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
//        [[AppDelegate getInstance].statusBarBackground setHidden:NO];
        
//        UIImage * imageResult;
//        
//        if (!CGSizeEqualToSize(self.cropSize,CGSizeZero)){
//            CGSize sizeCrop;
//            
//            if (self.cropSize.width > 0 && self.cropSize.height > 0) {
//                
//                sizeCrop = self.cropSize;
//                
//            }
//            else {
//                // 计算纵横比
//                if (self.cropSize.width > 0) {
//                    sizeCrop.width = self.cropSize.width;
//                    
//                    sizeCrop.height = imageSource.size.height * (sizeCrop.width / imageSource.size.width);
//                }
//                else {
//                    sizeCrop.height = self.cropSize.height;
//                    
//                    sizeCrop.width = imageSource.size.width * (sizeCrop.height / imageSource.size.height);
//                }
//            }
//            
//            imageResult = [UIImagePickerManager imageWithImageSimple:imageSource scaledToSize:sizeCrop];
//        }
//        else {
//            imageResult = imageSource;
//        }
//        
//        if (self.imagePickerBlock) {
//            self.imagePickerBlock(imageSource);
//        }
        
    }];
    
    
    
    
    
//    UIImage *img = [UIImage imageNamed:@"some.png"];
//    
//    NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
    
    
    
//    //下面是sdk中UIImage.h头文件中的内容
//    
//    UIKIT_EXTERN NSData *UIImagePNGRepresentation(UIImage *image);
//    
//    // return image as PNG. May return nil if image has no CGImageRef or invalid bitmap format
//    
//    UIKIT_EXTERN NSData *UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality);
//    
//    // return image as JPEG. May return nil if image has no CGImageRef or invalid bitmap format. compression is 0(most)..1(least)
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
//        [[AppDelegate getInstance].statusBarBackground setHidden:NO];
    }];
}

#pragma mark
#pragma mack 压缩图片
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
