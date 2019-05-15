//
//  waitForPayTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "waitForPayCollectionCell.h"
@class orderModel;
@protocol waitForPayDelegate <NSObject>
-(void)waitPayclickItemToDetailWithOrderSn:(NSString*)ordersn withStatus:(NSInteger)status;

@end
@interface waitForPayTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,waitForPayDelegate,mineOrderMorePartDelegate>
@property(nonatomic, strong) orderModel *model;
@property (nonatomic, retain) UIButton *payFor;  //付款
@property (nonatomic, weak) id<waitForPayDelegate>delegate;
@property (nonatomic, retain) UIButton *cancelOrder; //取消订单
@end
