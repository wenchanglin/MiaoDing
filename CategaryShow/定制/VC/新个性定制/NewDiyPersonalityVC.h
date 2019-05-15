//
//  NewDiyPersonalityVC.h
//  CategaryShow
//
//  Created by 文长林 on 2018/4/3.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "diyClothesDetailModel.h"
@interface NewDiyPersonalityVC : BaseViewController
@property(nonatomic,strong)diyClothesDetailModel*diyDetailModel;
@property (nonatomic, retain) NSMutableArray *goodArray;
@property (nonatomic, retain) NSMutableDictionary *goodDic;
@property (nonatomic, retain) NSDictionary *price;
@property(nonatomic,strong)NSDictionary* banxing;
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
