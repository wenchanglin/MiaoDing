//
//  waitForPayTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/17.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class orderModel;

@protocol waitForPayDelegate <NSObject>

-(void)clickItem:(NSInteger )item :(NSInteger)type;

@end

@interface waitForPayTableViewCell : UITableViewCell
@property(nonatomic, strong) orderModel *model;
@property (nonatomic, weak) id<waitForPayDelegate>delegate;
@property (nonatomic, retain) UIButton *payFor;  //付款

@property (nonatomic, retain) UIButton *cancelOrder; //取消订单
@end
