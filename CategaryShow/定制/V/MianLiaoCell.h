//
//  MianLiaoCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/11.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol mianLiaoDelegate <NSObject>

-(void)mianLiaoClick:(NSInteger)index;

@end
@interface MianLiaoCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak)id<mianLiaoDelegate>delegate;
@property (nonatomic, retain) NSMutableArray *mianLiaoArray;


@end
