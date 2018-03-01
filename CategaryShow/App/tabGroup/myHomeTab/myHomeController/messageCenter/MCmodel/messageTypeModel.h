//
//  messageTypeModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/4.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageTypeModel : NSObject
@property (nonatomic, retain) NSString *messageImage;
@property (nonatomic, retain) NSString *messageName;
@property (nonatomic, retain) NSMutableDictionary *messageLastMsg;
@property (nonatomic, retain) NSString *messageId;
@property (nonatomic, retain) NSString *messageType;
@property (nonatomic, retain) NSString *unReadCount;
@end
