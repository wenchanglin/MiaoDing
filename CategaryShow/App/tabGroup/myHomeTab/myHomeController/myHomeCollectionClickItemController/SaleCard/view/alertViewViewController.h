//
//  alertViewViewController.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "BaseViewController.h"
@protocol alertChooseDelegate <NSObject>

-(void)doneClickActin:(NSString *)code;

@end
@interface alertViewViewController : BaseViewController
@property (nonatomic, strong)id<alertChooseDelegate>delegate;
@end
