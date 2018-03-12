//
//  DesignerZuoPinCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/10.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDesignerModel.h"
@interface DesignerZuoPinCell : UITableViewCell
@property(nonatomic,strong)UIButton * zhuanFaBtn;
@property(nonatomic,strong)UIButton * shouChangBtn;
@property(nonatomic,strong)UIButton * loveBtn;
@property(nonatomic,strong)UIButton * commentBtn;
@property(nonatomic,strong)DesignerGoodsListModel* models;
@property(nonatomic) void(^ZuoPinFourBtns)(UIButton * buttons);

@end
