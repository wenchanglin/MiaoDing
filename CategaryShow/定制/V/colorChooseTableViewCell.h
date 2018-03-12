//
//  colorChooseTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol colorDelegate <NSObject>

-(void)colorClick:(NSInteger)index;

@end

@interface colorChooseTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak)id<colorDelegate>delegate;
@property (nonatomic, retain) NSMutableArray *colorArray;

@end
