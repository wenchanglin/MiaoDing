//
//  MeasurePlaceTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/9/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeasureLabelAndTextFieldModel;

@protocol measurePlaceDelegate <NSObject>

-(void)placeDetail:(NSString *)detail index:(NSInteger)index;
-(void)endEdit:(NSString*)edit index:(NSInteger)index;

@end

@interface MeasurePlaceTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong)MeasureLabelAndTextFieldModel *model;

@property(nonatomic, weak)id<measurePlaceDelegate>   delegate;
@end
