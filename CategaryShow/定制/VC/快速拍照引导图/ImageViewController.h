//
//  ImageViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ImageViewController : BaseViewController
- (instancetype)initWithImage:(UIImage *)image;
@property (nonatomic, assign) CGFloat bodyHeight;
@end
