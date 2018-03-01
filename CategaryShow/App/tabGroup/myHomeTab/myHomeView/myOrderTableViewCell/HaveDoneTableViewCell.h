//
//  HaveDoneTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/29.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"

@interface HaveDoneTableViewCell : UITableViewCell
@property(nonatomic, strong) orderModel *model;

@property (nonatomic, retain) UIButton *commendBtn;  //评论

@end
