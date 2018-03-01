//
//  DesignerForCollectionViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "designerModel.h"



@interface DesignerForCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) designerModel *model;
@property (nonatomic, retain) UIButton *designer;

@end
