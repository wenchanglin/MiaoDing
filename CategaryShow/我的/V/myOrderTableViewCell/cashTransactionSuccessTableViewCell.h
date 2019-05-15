//
//  cashTransactionSuccessTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "waitForPayCollectionCell.h"
@class orderModel;
@protocol orderCompelDelegate <NSObject>
-(void)orderCompelClickItemToDetailWithOrderSn:(NSString*)ordersn withStatus:(NSInteger)status;

@end
@interface cashTransactionSuccessTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,mineOrderMorePartDelegate>
@property(nonatomic, strong) orderModel *model;

@property (nonatomic, retain) UIButton *logistics;  //物流
@property(nonatomic,weak)id<orderCompelDelegate>delegate;
@property (nonatomic, retain) UIButton *confirm;  //确认收货
@end
