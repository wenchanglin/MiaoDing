//
//  myBagModel.h
//  CategaryShow
//
//  Created by APPLE on 16/9/18.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myBagModel : NSObject

@property (nonatomic, retain) NSString *clothesImg;  //衣服图片
@property (nonatomic, retain) NSString *clothesName;  //衣服名字
@property (nonatomic, retain) NSString *clothesPrice; //衣服价格
@property (nonatomic, retain) NSString *clothesCount; //衣服数量
@property (nonatomic, retain) NSString *ifChoose;  //是否选择了
@property (nonatomic, retain) NSString *bagId;
@property (nonatomic, retain) NSString *good_type;
@property (nonatomic, retain) NSString *good_id;


@property (nonatomic, assign) NSInteger can_use_card;
@property (nonatomic, retain) NSString *sizeOrDing;
@end
