//
//  WeiBoApiManager.m
//  百大悦城
//
//  Created by 文长林 on 2018/7/18.
//  Copyright © 2018年 文长林. All rights reserved.
//

#import "WeiBoApiManager.h"
@implementation WeiBoApiManager
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WeiBoApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeiBoApiManager alloc] init];
    });
    return instance;
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    WCLLog(@"%@",response);
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
 

}
@end
