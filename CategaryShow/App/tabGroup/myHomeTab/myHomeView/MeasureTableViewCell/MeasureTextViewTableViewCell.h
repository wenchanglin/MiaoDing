//
//  MeasureTextViewTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureLabelAndTextFieldModel.h"

@protocol MeasureTextViewDelegate <NSObject>

-(void)remarkDetail:(NSString *)detail;

@end

@interface MeasureTextViewTableViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic, strong)MeasureLabelAndTextFieldModel *model;

@property (nonatomic, retain)id<MeasureTextViewDelegate>delegata;

@end
