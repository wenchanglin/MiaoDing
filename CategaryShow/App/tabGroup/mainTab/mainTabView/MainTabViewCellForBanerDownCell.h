//
//  MainTabViewCellForBanerDownCell.h
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

// four symbol（标志）under the baner
#import "MianTabFourCollectionCell.h"
#import <UIKit/UIKit.h>

@protocol CellForBanerDownDelegate <NSObject>

@optional
- (void)collectionSelect:(NSArray *)array :(NSInteger)item;  //click action

@end
@interface MainTabViewCellForBanerDownCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id<CellForBanerDownDelegate> delegate;
@property (nonatomic, retain) UICollectionView *collect;   // user the collection to show the under four symbol
@property (nonatomic, retain) NSMutableArray *titleArray;  // sumbol's name
@property (nonatomic, retain) NSMutableArray *imageArray;  // sumbol's image




@end
