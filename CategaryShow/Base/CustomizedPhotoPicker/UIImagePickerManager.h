//
//  UIImagePickerManager.h
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/25.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ImagePickerBlock)(UIImage * resultImage);

@interface UIImagePickerManager : NSObject

+ (instancetype) getInstance;

- (void) show : (UIViewController *) viewController allowsEditing:(Boolean) allowsEditing cropSize:(CGSize) cropSize finish:(ImagePickerBlock) success;

@end
