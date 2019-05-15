//
//  waitForPayCollectionCell.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/22.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderModel.h"
#import "UILabel+YBAttributeTextTapAction.h"

NS_ASSUME_NONNULL_BEGIN
@protocol mineOrderMorePartDelegate <NSObject>
-(void)clickMineOrderListMoreLabel:(NSInteger)item;
@end
@interface waitForPayCollectionCell : UICollectionViewCell<YBAttributeTapActionDelegate>
@property(nonatomic,assign)NSInteger itemIdex;
@property(nonatomic,strong)childOrdersModel*model;
@property(nonatomic,weak)id<mineOrderMorePartDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
