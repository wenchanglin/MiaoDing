//
//  MyOrderDetailTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderDetailTableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *orderNumber;  //订单编号
@property (nonatomic, retain) UILabel *orderCreateTime; //订单支付时间
@property (nonatomic, retain) UILabel *orderPayTime; //订单支付时间
@property (nonatomic, retain) UILabel *orderStatus;

@end
