//
//  alertViewViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

typedef void(^giftCardExchage)(NSString*card,NSString*code);
@interface giftCardExchangeView : UIView
+(void)showGiftCardViewWithDoneBlock:(giftCardExchage)doneBlock;
@end
