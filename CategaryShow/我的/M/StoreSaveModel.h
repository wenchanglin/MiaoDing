//
//  StoreSaveModel.h
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreSaveModel : NSObject
@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)NSString *factory_img;
@property(nonatomic,strong)NSString *factory_name;
@property(nonatomic)NSInteger ID;
@property(nonatomic)NSInteger rid;
@property(nonatomic)NSInteger lovenum;
@property(nonatomic,strong)NSString* info;
@property(nonatomic)NSInteger type;
@end
