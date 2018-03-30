//
//  StoreSaveCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreSaveModel.h"
@interface StoreSaveCell : UITableViewCell
@property(nonatomic,strong)UIImageView * tupianImageView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * fansLabel;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)StoreSaveModel * model;
@end
