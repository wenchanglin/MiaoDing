//
//  joinDesTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol joinDesDelegate <NSObject>

-(void)collectionClick:(NSInteger)item :(NSInteger) tag;

@end

@interface joinDesTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) UILabel *remarkLabel;
@property (nonatomic, retain) UICollectionView *collectionV;
@property (nonatomic, retain) NSMutableArray *photoArrayM;
@property (nonatomic, weak) id<joinDesDelegate>delegate;

@end
