//
//  designerinfoNewTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "designerModel.h"
@class designerinfoNewTableViewCell;
@protocol DesignerMoreBtnsClickDelegate<NSObject>
-(void)moreBtnClickWithBtnTag:(NSInteger)tag withModel:(designerModel*)model withCell:(designerinfoNewTableViewCell*)cell;
@end
@interface designerinfoNewTableViewCell : UITableViewCell
@property (nonatomic, strong) designerModel *model;
@property(nonatomic,strong)UIView * desinerView;
@property(nonatomic,strong)UIButton * zhuanFaBtn;
@property(nonatomic,strong)UIButton * shouChangBtn;
@property(nonatomic,strong)UIButton * loveBtn;
@property(nonatomic,strong)UIButton * commentBtn;
@property(nonatomic,weak)id<DesignerMoreBtnsClickDelegate>delegate;
@end
