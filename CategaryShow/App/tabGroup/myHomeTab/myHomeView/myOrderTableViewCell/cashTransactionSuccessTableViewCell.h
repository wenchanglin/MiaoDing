//
//  cashTransactionSuccessTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class orderModel;
@interface cashTransactionSuccessTableViewCell : UITableViewCell
@property(nonatomic, strong) orderModel *model;

@property (nonatomic, retain) UIButton *logistics;  //物流

@property (nonatomic, retain) UIButton *confirm;  //确认收货
@end
