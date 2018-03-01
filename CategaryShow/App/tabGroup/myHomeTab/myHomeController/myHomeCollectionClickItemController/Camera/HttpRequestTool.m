//
//  HttpRequestTool.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/8/25.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "HttpRequestTool.h"
#import "AFHTTPSessionManager.h"
@implementation HttpRequestTool



#pragma mark -- 上传图片 --

+ (void)uploadWithURLString:(NSString *)URLString

                 parameters:(id)parameters

                 uploadData:(NSData *)uploadData

                 uploadName:(NSString *)uploadName

                    success:(void (^)())success

                    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadData name:uploadName fileName:uploadName mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
            
        }
    }];
    
    
    
}


// 上传多张图片

+ (void)uploadMostImageWithURLString:(NSString *)URLString

                          parameters:(id)parameters

                         uploadDatas:(NSArray *)uploadDatas


                             success:(void (^)())success

                             failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i<[uploadDatas count]; i++) {
            NSData *image = uploadDatas[i];
            
            [formData appendPartWithFileData:image name:[NSString stringWithFormat:@"photos[%d]",i] fileName:[NSString stringWithFormat:@"image%d.png",i] mimeType:@"image/png"];
            
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
            
        }

    }];
    
    
    
}

@end
