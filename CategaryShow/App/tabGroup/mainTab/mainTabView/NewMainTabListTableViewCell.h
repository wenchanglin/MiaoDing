//
//  NewMainTabListTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMainModel.h"
@interface NewMainTabListTableViewCell : UITableViewCell
@property (nonatomic,strong) NewMainModel *model;
@property(nonatomic,strong)UIButton * zhuanFaBtn;
@property(nonatomic,strong)UIButton *shouCangBtn;
@property(nonatomic,strong)UIButton *xiHuanBtn;
@property(nonatomic,strong)UIButton *pingLunBtn;
@property(nonatomic,strong)UIView * lastView;
@end
