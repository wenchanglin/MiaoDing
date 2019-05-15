//
//  userInfoModel.h
//  CategaryShow
//
//  Created by APPLE on 16/8/9.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#define Histroy_UserName @"LoginUserName"
#define Histroy_Image @"LoginUserImage"



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface userInfoModel : NSObject<NSCoding>
@property(nonatomic,strong)NSString*user_phone;
@property (nonatomic,assign) NSInteger  uid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString* is_yuyue;
@property(nonatomic,strong)NSString* age;
@property (nonatomic, assign) NSInteger unread_message_num;
@property (nonatomic,strong) NSString *username;


@end
