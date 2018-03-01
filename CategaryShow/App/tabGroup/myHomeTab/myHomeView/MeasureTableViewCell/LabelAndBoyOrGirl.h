//
//  LabelAndBoyOrGirl.h
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKColorSwitch.h"
@class MeasureLabelAndTextFieldModel;
@interface LabelAndBoyOrGirl : UITableViewCell
@property (nonatomic, strong) MeasureLabelAndTextFieldModel *model;
@property (nonatomic, retain) NKColorSwitch *swithGirlOrBoy;
@end
