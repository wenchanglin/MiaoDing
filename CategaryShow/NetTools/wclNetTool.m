//
//  wclNetTool.m
//  ceshi
//
//  Created by banbo on 2017/9/12.
//  Copyright © 2017年 banbo. All rights reserved.
//

#import "wclNetTool.h"
@interface wclNetTool ()

@end
@implementation wclNetTool
+(instancetype)sharedTools
{
    static wclNetTool * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]initWithBaseURL:[NSURL URLWithString:[MoreUrlInterface URL_Server_String]]];
        tool.securityPolicy.allowInvalidCertificates = YES;
        tool.securityPolicy.validatesDomainName = NO;
        tool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", nil];
        tool.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    });
    return tool;
}


- (void)request:(HTTPMethod)method urlString:(NSString *)urlString parameters:(NSMutableDictionary *)parameters finished:(void (^)(id responseObject, NSError *error))finished {
     NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    WCLLog(@"method:%ld,path:%@%@,parameters:%@,token=%@",(long)method,[MoreUrlInterface URL_Server_String],urlString,parameters,[userd stringForKey:@"token"]);
    if (method == GET) {
        if ([[userd stringForKey:@"token"]length] > 0 ) {
            NSString * str1 = [userd stringForKey:@"token"];
            [parameters setObject:str1 forKey:@"token"];
        }
        [[wclNetTool sharedTools] GET:urlString parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finished(responseObject,nil);
            [task cancel];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finished(nil,error);
            [task cancel];
        }];
    } else {
        if ([[userd stringForKey:@"token"]length] > 0 ) {
            [parameters setObject:[userd stringForKey:@"token"] forKey:@"token"];
        }
        [[wclNetTool sharedTools] POST:urlString parameters:parameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finished(responseObject,nil);
            [task cancel];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finished(nil,error);
            [task cancel];
        }];
    }
}

@end
