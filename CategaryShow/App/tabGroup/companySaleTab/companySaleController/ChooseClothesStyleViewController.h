
//
//  ChooseClothesStyleViewController.h
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
#import "MagnifierView.h"



@interface ChooseClothesStyleViewController : BaseViewController
@property(nonatomic,strong)NSMutableDictionary * paramsClothes;
@property (nonatomic, retain) NSMutableDictionary *goodDic;
@property(nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic, retain) NSMutableDictionary *xiuZiDic;
@property(nonatomic,strong)NSMutableArray * diyArray;
@property(nonatomic)NSInteger banxingtag;
@property (nonatomic, retain) NSDate *dingDate;
@property (nonatomic, retain) NSString *dateId;
@property(nonatomic,strong)NSDictionary * banxing;
@property (nonatomic, retain) NSString *price_Type;
@property(nonatomic,strong)NSString *  mianliaoprice;
@property (nonatomic, retain) NSDictionary *price;
@property (strong , nonatomic) MagnifierView* loop;
@property (strong , nonatomic) NSTimer* touchTimer;
@property (nonatomic, retain) NSString *class_id;
@end
