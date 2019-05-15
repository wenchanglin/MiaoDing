//
//  messageListModel.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageListModel : NSObject
@property (nonatomic, strong) NSString *car_img;
@property(nonatomic,assign)NSInteger category_id;
@property(nonatomic,strong)NSString*goods_id;
@property(nonatomic,strong)NSString*goods_name;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *msg_img;
@property (nonatomic, strong) NSString *re_marks;
@property(nonatomic,strong)NSString*express_no;
@property(nonatomic,assign)NSInteger status;
@property (nonatomic, strong) NSString *status_txt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *type_txt;
@property(nonatomic,strong)NSString*username;
@property(nonatomic,strong)NSString*uer_phone;
@property(nonatomic,assign)NSInteger ID;
@end
