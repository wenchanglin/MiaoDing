//
//  ChooseClothesResultViewController.h
//  CategaryShow
//
//  Created by APPLE on 16/8/30.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface ChooseClothesResultViewController : BaseViewController

@property (nonatomic, retain) NSMutableArray *goodArray;
@property (nonatomic, retain) NSString *price;


@property (nonatomic, retain) NSMutableDictionary *goodDic;
@property (nonatomic, retain) NSMutableArray *diyArray;

@property (nonatomic, retain) NSMutableArray *diyDetailArray;

@property (nonatomic, retain) NSMutableDictionary *xiuZiDic;

@property (nonatomic, retain) NSMutableDictionary *paramsClothes;

@property (nonatomic, retain) NSDate *dingDate;
@property (nonatomic, retain) NSString *dateId;

@property (nonatomic, retain) NSMutableDictionary *banMian;

@property (nonatomic, assign) BOOL ifTK;
@property (nonatomic, retain) NSString *defaultImg;
@end
