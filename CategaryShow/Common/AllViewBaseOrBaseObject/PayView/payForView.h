//
//  payForView.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol payForViewDelegate <NSObject>

@optional
- (void)cancelClick;
- (void)payClick;
- (void)clickItem:(NSInteger)item;

@end

@interface payForView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSString *price;
@property (nonatomic, weak) id <payForViewDelegate> delegate;
@property(nonatomic,strong)    UILabel *priceLable;
@property(nonatomic,strong)UILabel * hejiLabel;
-(void)reloadView;

@end
