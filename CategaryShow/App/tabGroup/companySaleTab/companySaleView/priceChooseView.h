//
//  priceChooseView.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "choosePriceModel.h"

@protocol priceChooseViewDelegate <NSObject>

-(void)clickPriceChoose:(NSInteger)item;

@end

@interface priceChooseView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign)id<priceChooseViewDelegate> delegate;
@property (nonatomic, retain) choosePriceModel *model;
@property (nonatomic, retain) NSMutableArray *priceArray;
@property (nonatomic, retain) NSMutableArray *priceTitleArray;


@end
