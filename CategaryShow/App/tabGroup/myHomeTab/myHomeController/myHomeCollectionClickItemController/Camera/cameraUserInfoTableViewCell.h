//
//  cameraUserInfoTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureLabelAndTextFieldModel.h"
@protocol cameraUserInfoDelegate <NSObject>

-(void)textDetail:(NSString *)detail :(NSInteger)index;

@end

@interface cameraUserInfoTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong)MeasureLabelAndTextFieldModel *model;
@property (nonatomic, assign) id<cameraUserInfoDelegate>delegate;
@end
