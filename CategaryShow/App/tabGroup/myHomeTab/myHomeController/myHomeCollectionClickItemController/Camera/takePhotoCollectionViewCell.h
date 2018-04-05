//
//  takePhotoCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photoModel.h"
@interface takePhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) photoModel *model;
@property(nonatomic,strong) UIImageView *imagePhoto;
@property(nonatomic,strong)UIButton * nextStep;
@end
