//
//  userInfoModel.m
//  CategaryShow
//
//  Created by APPLE on 16/8/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "userInfoModel.h"
@implementation userInfoModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user_phone forKey:@"user_phone"];
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    [aCoder encodeInteger:self.unread_message_num forKey:@"unread_message_num"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.is_yuyue forKey:@"is_yuyue"];
    [aCoder encodeObject:self.username forKey:@"username"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self==[super init]) {
        self.user_phone = [aDecoder decodeObjectForKey:@"user_phone"];
        self.uid = [aDecoder decodeIntegerForKey:@"uid"];
        self.unread_message_num = [aDecoder decodeIntegerForKey:@"unread_message_num"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.is_yuyue = [aDecoder decodeObjectForKey:@"is_yuyue"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
    }
    return self;
}
Description
@end
