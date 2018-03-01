//
//  moreQYTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moreQYCollectionViewCell.h"
@interface moreQYTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSMutableArray *collectionArray;
@property (nonatomic, retain) UILabel *titleLabel;

@end
