//
//  messageTypeModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/4.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageTypeModel : NSObject
@property (nonatomic, retain) NSString *img;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger unread_message_num;
@end
