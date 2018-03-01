//
//  commentHaveImageTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"



@protocol commentDelegate <NSObject>

-(void)clickCollectionItem:(NSInteger)item tag:(NSInteger)tag;

@end

@interface commentHaveImageTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) id<commentDelegate>delegate;
@property (nonatomic, retain) commentModel *model;

@end
