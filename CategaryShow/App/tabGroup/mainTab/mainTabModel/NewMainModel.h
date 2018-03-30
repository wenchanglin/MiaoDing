//
//  NewMainModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/17.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewMainModel : NSObject

@property (nonatomic, retain) NSString *ImageUrl;
@property (nonatomic, retain) NSString *linkUrl;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *LinkId;
@property(nonatomic,strong)NSString * img_new;
@property(nonatomic,strong)  NSString * img_info;
@property(nonatomic)NSInteger is_type;
@property (nonatomic, retain) NSString *titleContent;
@property (nonatomic, retain) NSString *fenLei;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *tagName;
@property(nonatomic)NSInteger  is_love;
@property(nonatomic)NSInteger is_collect;
@property(nonatomic)NSInteger commentnum;
@property(nonatomic)NSInteger lovenum;
@property (nonatomic, retain) NSString *subTitle;
@end
