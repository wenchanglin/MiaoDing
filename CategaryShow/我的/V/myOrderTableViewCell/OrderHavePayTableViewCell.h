//
//  OrderHavePayTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHavePayTableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *orderNumber;  //订单编号
@property (nonatomic, retain) UILabel *orderCreateTime; //订单支付时间
@property (nonatomic, retain) UILabel *orderPayTime; //订单支付时间
@property (nonatomic, retain) UILabel *orderStatus;
@end
