//
//  LabelAndChooseTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSComboListView.h"
@class MeasureLabelAndTextFieldModel;

@interface LabelAndChooseTableViewCell : UITableViewCell<FSComboPickerViewDelegate>

@property (nonatomic, retain) MeasureLabelAndTextFieldModel *model;
@end
