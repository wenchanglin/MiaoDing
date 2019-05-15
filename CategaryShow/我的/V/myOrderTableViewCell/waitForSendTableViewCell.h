//
//  waitForSendTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"
#import "waitForPayCollectionCell.h"
@protocol waitForSendClickItemDelegate<NSObject>
-(void)clickItemToDetailWithOrderSn:(NSString*)ordersn withStatus:(NSInteger)status;
@end
@interface waitForSendTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,mineOrderMorePartDelegate>
@property(nonatomic, strong) orderModel *model;
@property (nonatomic, retain) UIButton *woring;  //提醒
@property(nonatomic,weak)id<waitForSendClickItemDelegate>delegate;

@end
