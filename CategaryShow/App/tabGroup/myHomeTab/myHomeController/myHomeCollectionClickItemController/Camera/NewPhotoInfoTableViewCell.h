//
//  NewPhotoInfoTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/7/18.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewPhotoInfoTableViewCellDelegate <NSObject>

-(void)textDetail:(NSString *)detail :(NSInteger)index;

@end

@interface NewPhotoInfoTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITextField *detailText;

@property (nonatomic, retain) UILabel *unitLabel;
@property (nonatomic, assign) id<NewPhotoInfoTableViewCellDelegate>delegate;
@end
