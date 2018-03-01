
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
@property (nonatomic, retain) NSMutableDictionary *goodDic;
@property (nonatomic, retain) NSString *price_Type;
@property (nonatomic, retain) NSDictionary *price;
@property (strong , nonatomic) MagnifierView* loop;
@property (strong , nonatomic) NSTimer* touchTimer;
@property (nonatomic, retain) NSString *class_id;
@end
