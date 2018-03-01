//
//  HttpRequestTool.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/8/25.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestTool : NSObject




// 上传图片

+ (void)uploadWithURLString:(NSString *)URLString

                 parameters:(id)parameters

                 uploadData:(NSData *)uploadData

                 uploadName:(NSString *)uploadName

                    success:(void (^)())success

                    failure:(void (^)(NSError *))failure;


// 上传多张图片

+ (void)uploadMostImageWithURLString:(NSString *)URLString

                          parameters:(id)parameters

                         uploadDatas:(NSArray *)uploadDatas

                             success:(void (^)())success

                             failure:(void (^)(NSError *))failure;



@end


