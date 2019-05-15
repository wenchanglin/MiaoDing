//
//  WLTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/11/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wuLiuModel.h"
@interface WLTableViewCell : UITableViewCell

@property (nonatomic, retain) wuLiuModel *model;
@property (nonatomic, retain) UIView *topLine;
@property (nonatomic, retain) UIView *downLine;
@end
