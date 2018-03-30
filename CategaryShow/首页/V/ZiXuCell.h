//
//  ZiXuCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/15.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZiXunModel.h"
@interface ZiXuCell : UITableViewCell
@property(nonatomic,strong)ZiXunModel * models;
@property(nonatomic,strong)UIViewController * VC;
@property(nonatomic,strong) UIImageView *mainImg;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong)UILabel * headLabel;
@property(nonatomic,strong)UIButton * zhuanFaBtn;
@property(nonatomic,strong)UIButton *shouCangBtn;
@property(nonatomic,strong)UIButton *xiHuanBtn;
@property(nonatomic,strong)UIButton *pingLunBtn;
@property(nonatomic,strong)UIView * lastView;
@property(nonatomic) void(^FourBtn)(UIButton * buttons);
@end
