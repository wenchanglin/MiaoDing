//
//  SelfPersonInfo.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/22.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "SelfPersonInfo.h"
#import "NSDictionary+EmptyString.h"
#import "JSONKit.h"
#import "BaseDomain.h"

static SelfPersonInfo * _personInfo;

@implementation SelfPersonInfo

+ (instancetype) getInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_personInfo == nil) {
            _personInfo = [[SelfPersonInfo alloc] init];
            
            [_personInfo setPersonInfoFromJsonData : nil];
        }
    });
    
    return _personInfo;
}

/**
 * 初始化人物信息
 *
 * @param jsonData
 *            人物信息Json
 */
- (void) setPersonInfoFromJsonData : (NSDictionary *) jsonData {
    @try {
        
        if (jsonData == nil) {
            jsonData = [self getPersonInfoJsonData];
        }
        
        if (jsonData == nil) {
            return;
        }
        
        NSDictionary * jsonPeronData = [jsonData objectForKey:JSON_Header_DataObject];
        
        if (jsonPeronData != nil) {
        
            // 人物pKey
            
            self.personUserKey = [jsonPeronData stringForKey:@"uid"];
            self.personImageUrl = [jsonPeronData stringForKey:@"avatar"];
            
            self.cnPersonUserName = [jsonPeronData stringForKey:@"name"];
            self.personNickName = [jsonPeronData stringForKey:@"nickname"];
            
            self.personUserCode = [jsonPeronData stringForKey:@"account"];
            
            self.personYuYue = [jsonPeronData stringForKey:@"is_yuyue"];
            
            self.personPhone = [jsonPeronData stringForKey:@"phone"];
            // 人物出生日期
            self.personBirthday = [jsonPeronData stringForKey:@"birthday"];
            self.personAge = [jsonPeronData stringForKey:@"age"];
            
            
            
            
            self.personPassword = [jsonPeronData stringForKey:@"password"];
            self.personAdminKey = [[jsonPeronData objectForKey:@"companyeo"] stringForKey:@"userKey"];
            self.personCompanyLv = [[jsonPeronData objectForKey:@"companyeo"] stringForKey:@"lv"];
            self.personRoleArray = [[jsonPeronData dictionaryForKey:@"role"] arrayForKey:@"purview"];
            
            self.roleName = [[jsonPeronData dictionaryForKey:@"role"] stringForKey:@"cnName"];
            
            self.personCompanyUrl = [[jsonPeronData objectForKey:@"companyeo"] stringForKey:@"imgUrl"];
            // 人物所在城市Code
            self.personCityName = [jsonPeronData stringForKey:@"city"];
            self.personCompanyStatus = [jsonPeronData stringForKey:@"statusCompany"];
            self.personCompanyKey = [jsonPeronData stringForKey:@"companyKey"];
             self.personCompanyShow = [jsonPeronData stringForKey:@"companyShow"];
            // 人物签名
            self.personSignName = [jsonPeronData stringForKey:@"signing"];
            // 人物性别 0 男 1 女
            self.personSex = [jsonPeronData stringForKey:@"sex"];
            
            
            self.personImageList = [jsonPeronData objectForKey:@"imageList"];
            
            self.personIdCardStatus = [jsonPeronData stringForKey:@"statusIdCard"];
            
            
            self.personQQNumber = [jsonPeronData stringForKey:@"qq"];
            self.personWeiChatNumber = [jsonPeronData stringForKey:@"weixin"];
            
            
            self.personWeight = [jsonPeronData stringForKey:@"weight"];
            self.personHeight= [jsonPeronData stringForKey:@"height"];
            self.personJob= [jsonPeronData stringForKey:@"position"];
            self.personConstellation= [jsonPeronData stringForKey:@"constellation"];
            self.personZone= [jsonPeronData stringForKey:@"zone"];
            self.personSchool= [jsonPeronData stringForKey:@"school"];
            self.personProfession= [jsonPeronData stringForKey:@"profession"];
            
        }
        
    } @catch (NSException * ex) {
        
    }
    
}

- (NSDictionary *) getPersonInfoJsonData {
    
    NSDictionary * jsonData = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    @try {
        
        NSString * strJson = [[NSUserDefaults standardUserDefaults] stringForKey:PersonHistoryKey];
        
        NSData * nsData = [strJson JSONData];
        
        jsonData = [nsData objectFromJSONData];
        
    } @catch (NSException * ex) {
        
    }

    return jsonData;
}

+ (NSString *) getPersonSexName : (int) intSex {
    if (intSex == 0)
        return NSLocalizedString(@"sex_boy", nil);
    else
        return NSLocalizedString(@"sex_girl", nil);
}



@end
