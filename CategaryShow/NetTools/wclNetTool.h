//
//  wclNetTool.h
//  ceshi
//
//  Created by banbo on 2017/9/12.
//  Copyright © 2017年 banbo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSInteger)
{
    GET,
    POST,
}HTTPMethod;
@interface wclNetTool : AFHTTPSessionManager
+ (instancetype) sharedTools;
- (void) request:(HTTPMethod)method urlString:(NSString *)urlString  parameters:(id)parameters finished:(void(^)(id responseObject,NSError * error))finished;

@end
