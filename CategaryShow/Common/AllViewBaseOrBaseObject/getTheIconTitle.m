//
//  getTheIconTitle.m
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "getTheIconTitle.h"
static getTheIconTitle * _titleIcon;
@implementation getTheIconTitle


+ (instancetype) getInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_titleIcon == nil) {
            _titleIcon = [[getTheIconTitle alloc] init];
            
            [_titleIcon getNotforOrForCollectionTitleAndIcon];
        }
    });
    
    return _titleIcon;
}


-(void)getNotforOrForCollectionTitleAndIcon
{
    self.titleForCollection = [NSMutableArray arrayWithObjects:@"我的订单",@"购物袋", @"我的收藏", @"穿衣测试", @"上门裁体", @"私人顾问", @"衣物志", @"设计师入驻", nil];
    self.titleNotForCollection =[NSMutableArray arrayWithObjects:@"意见与反馈",@"设置", nil];
    
    self.iconForCollection = [NSMutableArray arrayWithObjects:@"MyDIngD",@"BuyBag", @"Mysave",@"Wear",@"BodyCeLiage",@"Siren", @"Baike",@"ShejiShi", nil];
    
    self.iconNotForCollection = [NSMutableArray arrayWithObjects:@"SuggestHelp",@"mySet", nil];
    
    self.titleForMainTabCollection = [NSMutableArray arrayWithObjects:@"今日推荐", @"上门裁体", @"衣物志", @"私人顾问", nil];
    
    self.iconForMainTabCollection = [NSMutableArray arrayWithObjects:@"JR", @"BodyCeLiage", @"Baike", @"Siren", nil];
    
}



@end
