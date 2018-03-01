//
//  vipQuanYiCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/16.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol vipQuanYiCollectionViewCellDelegate <NSObject>

@optional
- (void)collectionSelect:(NSMutableArray *)array :(NSInteger)item;  //click action

@end
@interface vipQuanYiCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id<vipQuanYiCollectionViewCellDelegate> delegate;
@property (nonatomic, retain) UICollectionView *collect;   // user the collection to show the under four symbol
@property (nonatomic, retain) NSMutableArray *titleArray;  // sumbol's name
@property (nonatomic, retain) NSMutableArray *imageArray;  // sumbol's image
@property (nonatomic, retain) NSMutableArray *realArray;
@end
