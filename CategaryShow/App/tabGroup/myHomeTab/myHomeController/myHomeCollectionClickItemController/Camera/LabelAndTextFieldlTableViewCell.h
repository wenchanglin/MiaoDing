//
//  LabelAndTextFieldlTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/15.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeasureLabelAndTextFieldModel;
@protocol LabelAndTextFieldlTableViewCellDelegate <NSObject>

-(void)textDetail:(NSString *)detail :(NSInteger)index;

@end

@interface LabelAndTextFieldlTableViewCell : UITableViewCell
@property (nonatomic, strong)MeasureLabelAndTextFieldModel *model;
@property (nonatomic, assign) id<LabelAndTextFieldlTableViewCellDelegate>delegate;
@end
