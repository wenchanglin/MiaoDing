//
//  myBagTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/18.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+YBAttributeTextTapAction.h"
@class myBagModel;
@protocol myBagTableViewCellDelegate <NSObject>

-(void)clickButton:(NSInteger)item;
-(void)clickMoreLabel:(NSInteger)item;
@end

@interface myBagTableViewCell : UITableViewCell<YBAttributeTapActionDelegate>
@property (nonatomic, weak) id<myBagTableViewCellDelegate>delegate;
@property (nonatomic, strong) myBagModel *model;
@property (nonatomic, retain) UIButton *addCount;
@property (nonatomic, retain) UIButton *cutCount;
@property(nonatomic,strong)UILabel*moreLabel;
@property (nonatomic, assign) BOOL updateIfOrNot;
@property (nonatomic, retain) UIView *lineView;
@end
