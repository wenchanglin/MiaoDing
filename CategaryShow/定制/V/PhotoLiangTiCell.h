//
//  PhotoLiangTiCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/4/24.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiangTiModel.h"
@interface PhotoLiangTiCell : UITableViewCell
@property(nonatomic,strong)UILabel * liangTiLabel;/**量体数据确认*/
@property(nonatomic,strong)UILabel * nameLabel;/**量体人姓名*/
@property(nonatomic,strong)UILabel * heightLabel;/**量体人身高*/
@property(nonatomic,strong)UILabel * weightLabel;/**量体人体重*/
@property(nonatomic,strong)LiangTiModel * models;
@end
