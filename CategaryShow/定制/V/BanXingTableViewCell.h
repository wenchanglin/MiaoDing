//
//  BanXingTableViewCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/11.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol banXingDelegate <NSObject>

-(void)banXingClick:(NSInteger)index;

@end
@interface BanXingTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak)id<banXingDelegate>delegate;
@property(nonatomic, retain) NSMutableArray *banXingArray;
@end
