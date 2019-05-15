//
//  myCollectModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/24.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface myCollectModel : NSObject
@property (nonatomic, retain) NSString *img;
@property(nonatomic,strong)NSString*img_info;
@property(nonatomic,assign)NSInteger goods_type;
@property (nonatomic, assign) NSInteger rid;
@property (nonatomic, retain) NSString *sub_name;
@property (nonatomic, retain) NSString *tags_name;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString*price;
@property(nonatomic,assign)NSInteger type;
@property (nonatomic, assign) NSInteger ID;
@end

NS_ASSUME_NONNULL_END
