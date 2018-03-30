//
//  StoresPicCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/19.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoresDetailModel.h"
@interface StoresPicCell : UITableViewCell
@property(nonatomic,strong) StoresDetailModel * models;
@property(nonatomic,strong)NSIndexPath * indexpath;
@property(nonatomic,strong)UIImageView * picIMgView;
-(void)setmodel:(StoresDetailModel *)models WithIndex:(NSIndexPath*)indexPath;
@end
