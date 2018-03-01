//
//  waitForSendTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"



@interface waitForSendTableViewCell : UITableViewCell
@property(nonatomic, strong) orderModel *model;

@property (nonatomic, retain) UIButton *woring;  //提醒


@end
