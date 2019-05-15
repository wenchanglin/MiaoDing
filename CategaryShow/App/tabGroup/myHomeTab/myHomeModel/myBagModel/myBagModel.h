//
//  myBagModel.h
//  CategaryShow
//
//  Created by APPLE on 16/9/18.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myBagModel : NSObject
@property(nonatomic,strong)NSString*cart_id;
@property (nonatomic, retain) NSString *category_id;  
@property (nonatomic, retain) NSString *goods_id;
@property (nonatomic, retain) NSString *goods_img;
@property (nonatomic, retain) NSString *goods_name;
@property (nonatomic, assign) NSInteger goods_num;
@property (nonatomic, retain) NSString *ifChoose;  //是否选择了
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *re_marks;
@property(nonatomic,strong)NSString* sizeOrDing;
@property(nonatomic,strong)NSArray*part;
@property(nonatomic,strong)NSArray*sku;
@end
@interface partModel : NSObject
@property (nonatomic, retain) NSString *part_name;
@property (nonatomic, retain) NSString *part_value;
@end
@interface skuModel : NSObject
@property(nonatomic,strong)NSString*type;
@property(nonatomic,strong)NSString*value;
@end
