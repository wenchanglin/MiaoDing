//
//  DesigherCollectionViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class designerModel;
@interface DesigherCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) designerModel *model;

@property (nonatomic, retain) UIButton *designerClick;
@property (nonatomic, retain) UIButton *clothesClick;

@end
