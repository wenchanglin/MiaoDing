//
//  MyOrderDetailListTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mineOrderDetailModel.h"
#import "waitForPayCollectionCell.h"
@interface MyOrderDetailListTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,mineOrderMorePartDelegate>
@property (nonatomic, strong) mineOrderDetailModel *model;
@end
