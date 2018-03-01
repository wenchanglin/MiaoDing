//
//  DesignerTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerCollectionViewCell.h"
#import "mainClothesSaleCollectionViewCell.h"
#import "NewDesignerArray.h"
@protocol DesignerTableViewCellDelegate <NSObject>

-(void)clickCollectionItem:(NSInteger)item;

@end

@interface DesignerTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NewDesignerArray *model;
@property (nonatomic, weak) id<DesignerTableViewCellDelegate>delegate;
@end
