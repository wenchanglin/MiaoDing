//
//  AddressModel.h
//  CategaryShow
//
//  Created by APPLE on 16/10/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property (nonatomic, retain) NSString *accept_name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *area;
@property (nonatomic, retain) NSString *country;
@property(nonatomic,strong)NSString*noAddressPic;
@end
