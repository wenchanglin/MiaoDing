//
//  designerForClothesCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "designerModel.h"

@interface designerForClothesCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) designerModel *model;

@property (nonatomic, retain) UIButton *headButn;

@property (nonatomic, retain) NSString *pictureUrl;

@property (nonatomic, retain) NSString *intro;

@end
