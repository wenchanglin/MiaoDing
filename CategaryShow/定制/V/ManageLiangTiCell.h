//
//  ManageLiangTiCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/4/24.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiangTiModel.h"
@protocol LiangTiAddDelegate <NSObject>

-(void)clickChooseLiangTi:(NSInteger )item;
-(void)clickUpdateLiangTi:(NSInteger )item;
-(void)clickDeleteAddress:(NSInteger )item;

@end
@interface ManageLiangTiCell : UITableViewCell
@property(nonatomic,strong)UIImageView * mainImageViews;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * heightLabel;
@property(nonatomic,strong)UILabel * weightLabel;
@property(nonatomic,strong)UIButton * chooseBtn;
//@property(nonatomic,strong)UIButton * updateBtn;
@property(nonatomic,weak)id<LiangTiAddDelegate>delegate;
@property(nonatomic,strong)LiangTiModel * models;
@end
