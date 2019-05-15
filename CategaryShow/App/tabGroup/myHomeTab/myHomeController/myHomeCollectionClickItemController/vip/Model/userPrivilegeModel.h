//
//  userPrivilegeModel.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/11.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface userPrivilegeModel : NSObject
@property(nonatomic,strong)NSString* desc;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,strong)NSString*img;
@property(nonatomic,strong)NSString*is_get;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*ratio;
@end

NS_ASSUME_NONNULL_END
