//
//  WCLMethodTools.m
//  CategaryShow
//
//  Created by 文长林 on 2019/1/11.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "WCLMethodTools.h"

@implementation WCLMethodTools
+ (void)headerRefreshWithTableView:(id )view completion:(void (^)(void))completion{
    
    MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        completion();
    }];
    
    //    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 30; i++) {
        @autoreleasepool {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [headerImages addObject:image];
        };
    }
    headerView.stateLabel.hidden = YES;
    headerView.lastUpdatedTimeLabel.hidden = YES;
    [headerView setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [headerView setImages:headerImages forState:MJRefreshStatePulling];
    [headerView setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)view;
        tableview.mj_header = headerView;
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_header = headerView;
    }
    
}

+ (void)footerRefreshWithTableView:(id )view completion:(void (^)(void))completion{
    
    MJRefreshBackStateFooter *footerR = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        completion();
    }];
    
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)view;
        tableview.mj_footer = footerR;
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_footer = footerR;
        
    }
}
+ (void)footerNormalRefreshWithTableView:(id )view completion:(void (^)(void))completion
{
    MJRefreshBackNormalFooter *footerR = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        completion();
    }];
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)view;
        tableview.mj_footer = footerR;
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_footer = footerR;
        
    }
}
+ (void)footerAutoGifRefreshWithTableView:(id )view completion:(void (^)(void))completion{
    
    MJRefreshBackGifFooter *footerR = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        completion();
    }];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i <= 30; i++) {
        @autoreleasepool {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [refreshingImages addObject:image];
        };
    }
    [footerR setImages:refreshingImages forState:MJRefreshStateIdle];
    
    [footerR setImages:refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footerR setImages:refreshingImages forState:MJRefreshStateRefreshing];
    footerR.stateLabel.hidden = YES;
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)view;
        tableview.mj_footer = footerR;
    } else if ([view isKindOfClass:[UICollectionView class]]){
        UICollectionView *tableview = (UICollectionView *)view;
        tableview.mj_footer = footerR;
        
    }
}
@end
