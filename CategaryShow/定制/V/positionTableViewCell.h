//
//  positionTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/27.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol positionDelegate <NSObject>

-(void)positionClick:(NSInteger)index;

@end

@interface positionTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak)id<positionDelegate>delegate;
@property(nonatomic, retain) NSMutableArray *positionArray;

@end
