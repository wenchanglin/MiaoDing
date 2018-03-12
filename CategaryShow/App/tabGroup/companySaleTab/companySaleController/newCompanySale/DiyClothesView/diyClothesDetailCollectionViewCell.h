//
//  diyClothesDetailCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "diyClothesDetailModel.h"
#import "YYCycleScrollView.h"


@protocol diyClothesDelegate <NSObject>

-(void)clickBanerItem:(NSInteger)item;

@end
@interface diyClothesDetailCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, retain) diyClothesDetailModel *model;

@property (nonatomic, retain) NSMutableArray *banerArray;

@property (nonatomic, retain) YYCycleScrollView *baner;

@property (nonatomic, retain) UIImageView *banerImg;

@property (nonatomic, retain) UICollectionView *clotehImageCollect;

@property (nonatomic, weak) id<diyClothesDelegate>delegate;

@end
