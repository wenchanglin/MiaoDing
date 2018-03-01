//
//  CommentCollectionViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/9.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "commentModel.h"

@interface CommentCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, retain) commentModel *modelComment;



@property (nonatomic, retain) UIButton *moreClick;

@end
