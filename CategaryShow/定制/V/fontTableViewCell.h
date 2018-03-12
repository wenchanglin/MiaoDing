//
//  fontTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol fontDelegate <NSObject>

-(void)fontChoose:(NSInteger)index;

@end

@interface fontTableViewCell : UITableViewCell
@property (nonatomic, weak)id<fontDelegate>delegate;
@property (nonatomic, retain) NSMutableArray *fontArray;

@end
