//
//  mainClothesSaleCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMainDesigner.h"


@interface mainClothesSaleCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) NewMainDesigner *designer;
@property (nonatomic, retain) UIImageView *imageDesigner;
@property (nonatomic, retain) UILabel *nameLabel;
@end
