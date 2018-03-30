//
//  StoreListCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/13.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreListModel.h"
@interface StoreListCell : UITableViewCell
@property(nonatomic,strong)UIImageView * mainImageView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * fansLabel;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)StoreListModel* model;
@end
