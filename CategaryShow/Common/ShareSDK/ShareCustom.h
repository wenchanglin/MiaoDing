//
//  ShareCustom.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareCustom : NSObject



+(void)shareWithContent:(id)publishContent;//自定义分享界面

+(void)shareContent:(id)publishContent controller:(UIViewController *)control;//自定义分享界面

@end
