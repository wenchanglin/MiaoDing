//
//  userGradeModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/11.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface userGradeModel : NSObject
@property(nonatomic,strong)NSString* img;
@property(nonatomic,strong)NSString* img2;
@property(nonatomic,strong)NSString* max_credit;
@property(nonatomic,strong)NSString*min_credit;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*ratio;
@property(nonatomic,strong)NSString*user_privilege_ids;
@property(nonatomic,strong)NSArray*listOfDetail;
@end

NS_ASSUME_NONNULL_END
