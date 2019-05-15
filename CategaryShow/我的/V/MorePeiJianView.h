//
//  MorePeiJianView.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/18.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UpdateVersionGoBlock)(NSString*string);
@interface MorePeiJianView : UIView
+(void)showWithData:(NSArray*)dataArr withTitle:(NSString*)title isChengPing:(NSInteger)ischengping withDoneBlock:(UpdateVersionGoBlock)doneBlock;
@end

NS_ASSUME_NONNULL_END
