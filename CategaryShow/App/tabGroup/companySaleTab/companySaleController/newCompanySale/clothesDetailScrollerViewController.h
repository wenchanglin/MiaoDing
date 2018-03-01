//
//  clothesDetailScrollerViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/15.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface clothesDetailScrollerViewController : BaseViewController

@property (nonatomic, retain) NSMutableDictionary *dataDictionary;

@property (nonatomic, retain) NSMutableDictionary *goodParams;

@property (nonatomic, retain) NSMutableDictionary *goodDic;
@property (nonatomic, retain) NSString *good_id;
@property (nonatomic, retain) NSString *class_id;
@property (nonatomic, retain) NSString *type_id;
@property (nonatomic, retain) NSMutableArray *goodArray;
@property (nonatomic, retain) NSString *default_price;;
@property (nonatomic, retain) NSString *goodDufaultImg;
@end
