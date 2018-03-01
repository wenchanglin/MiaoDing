//
//  uiimageShowViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/22.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface uiimageShowViewController : BaseViewController
@property(nonatomic ,strong) UIImageView *imageView;
@property(nonatomic ,strong) NSString *imageUrl;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) NSInteger index;


@property (nonatomic, retain) NSDictionary *goodDic;
@end
