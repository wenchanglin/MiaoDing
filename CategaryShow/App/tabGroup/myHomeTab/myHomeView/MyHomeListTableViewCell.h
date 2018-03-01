//
//  MyHomeListTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/8/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#import "MianTabFourCollectionCell.h"
#import <UIKit/UIKit.h>
@protocol MyHomeListTableViewCellDelegate <NSObject>

@optional
- (void)collectionSelect:(NSArray *)array :(NSInteger)item;  //click action

@end
@interface MyHomeListTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id<MyHomeListTableViewCellDelegate> delegate;



@property (nonatomic, retain) UICollectionView *collect;   // user the collection to show the under four symbol
@property (nonatomic, retain) NSMutableArray *titleArray;  // sumbol's name
@property (nonatomic, retain) NSMutableArray *imageArray;  // sumbol's image
@end
