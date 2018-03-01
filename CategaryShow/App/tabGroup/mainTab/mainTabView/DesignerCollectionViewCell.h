//
//  DesignerCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMainDesigner.h"
@interface DesignerCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) NewMainDesigner *designer;
@property (nonatomic, retain) UIImageView *imageDesigner;
@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *detail;



@end
