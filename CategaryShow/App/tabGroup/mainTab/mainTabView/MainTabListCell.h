//
//  MainTabListCell.h
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainTabModel;

@protocol MainTableDelegate <NSObject>

-(void)clickCollectionItem:(NSInteger)item tag:(NSInteger)tag;

@end

@interface MainTabListCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) MainTabModel *model;
@property (nonatomic, strong) id<MainTableDelegate>delegate;
@end
