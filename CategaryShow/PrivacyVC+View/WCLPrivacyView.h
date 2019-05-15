//
//  WCLPrivacyView.h
//  PhotoAppStore
//
//  Created by 文长林 on 2018/11/28.
//  Copyright © 2018年 黄梦炜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^privacyBlock)(NSInteger index);
typedef void(^agreeBlock)(void);
@interface WCLPrivacyView : UIView
@property(nonatomic,copy)privacyBlock privacyBlock;
@property(nonatomic,copy)agreeBlock agreeBlock;
@end

NS_ASSUME_NONNULL_END
