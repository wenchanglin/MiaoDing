//
//  orderUseGiftCardCell.h
//  CategaryShow
//
//  Created by 文长林 on 2019/1/17.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLSwitchView.h"
NS_ASSUME_NONNULL_BEGIN
@class orderUseGiftCardCell;
@protocol OrderUseAndExchangeGiftCardAndToPayDelegate <NSObject>
-(void)exChangeGiftCardwithCell:(orderUseGiftCardCell*)cell;
-(void)goToPaywithCell:(orderUseGiftCardCell*)cell;
@end
typedef void(^useGiftCard)(BOOL isuse);
@interface orderUseGiftCardCell : UITableViewCell
@property(nonatomic,strong)UILabel*firstLabel;
@property(nonatomic,strong)UIButton*switchView;
@property(nonatomic,strong)UILabel*giftCardLabel;
@property(nonatomic,strong)UILabel*heJiLabel;
@property(nonatomic,strong)UIButton*exchageBtn;
@property(nonatomic,strong)UIButton*toPayBtn;
@property(nonatomic,weak)id<OrderUseAndExchangeGiftCardAndToPayDelegate>delegate;
@property(nonatomic,copy)useGiftCard useGiftCardBlock;
@end

NS_ASSUME_NONNULL_END
