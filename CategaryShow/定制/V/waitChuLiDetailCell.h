//
//  waitChuLiDetailCell.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/17.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "waitChuLiModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface waitChuLiDetailCell : UITableViewCell
@property(nonatomic,strong)UILabel*yhqLabel;
@property(nonatomic,strong)UILabel*otherLabel;
@property(nonatomic,strong)UILabel*zekouLabel;
@property(nonatomic,strong)UILabel*shiJiLabel;
@property(nonatomic,strong)UILabel*priceLabel;
@property(nonatomic,strong)UIView*endView;
@property(nonatomic,strong)waitChuLiModel*model;
@end

NS_ASSUME_NONNULL_END
