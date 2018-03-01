//
//  designerHomeViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/6.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"

@interface designerHomeViewController : BaseViewController
@property (nonatomic, retain) NSString *desginerId;
@property (nonatomic, retain) NSString *designerName;
@property (nonatomic, retain) NSString *designerImage;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic, retain) NSString *designerStory;

@property (nonatomic, retain ) NSMutableDictionary *designerDic;
@end
