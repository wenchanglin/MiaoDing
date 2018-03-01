//
//  styleChoose.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "choosePriceModel.h"

@protocol styleChooseViewDelegate <NSObject>

-(void)clickStyleChoose:(NSInteger)item;

@end

@interface styleChoose : UIView<UITableViewDelegate, UITableViewDataSource>




@property(nonatomic, assign)id<styleChooseViewDelegate> delegate;
@property (nonatomic, retain) choosePriceModel *model;

@property (nonatomic, retain) NSMutableArray *priceTitleArray;

@end
