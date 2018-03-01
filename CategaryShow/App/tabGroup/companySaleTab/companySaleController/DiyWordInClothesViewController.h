//
//  DiyWordInClothesViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface DiyWordInClothesViewController : BaseViewController

@property (nonatomic, retain) NSMutableArray *goodArray;
@property (nonatomic, retain) NSMutableDictionary *goodDic;
@property (nonatomic, retain) NSDictionary *price;
@property (nonatomic, retain) NSString *price_type;
@property (nonatomic, retain) NSMutableDictionary *xiuZiDic;
@property (nonatomic, retain) NSString *class_id;

@property (nonatomic, retain) NSMutableDictionary *paramsDic;

@property (nonatomic, retain) NSString *dateId;
@property (nonatomic, retain) NSDate *dingDate;

@property (nonatomic, retain) NSString *banexingId;

@property (nonatomic, retain) NSMutableDictionary *banMain;


@property (nonatomic, assign) BOOL ifTK;
@property (nonatomic, retain) NSString *defaultImg;
@end
