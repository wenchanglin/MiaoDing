//
//  MeasureLabelAndTextField.h
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeasureLabelAndTextFieldModel;
@protocol measureLabelAndTextDelegate <NSObject>

-(void)textDetail:(NSString *)detail :(NSInteger)index;

@end


@interface MeasureLabelAndTextField : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong)MeasureLabelAndTextFieldModel *model;
@property (nonatomic, weak) id<measureLabelAndTextDelegate>delegate;
@end
