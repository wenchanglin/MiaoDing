//
//  HeightAndWeightCell.h
//  CategaryShow
//
//  Created by 文长林 on 2018/4/3.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeightAndWeightCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView * firstImageView;
@property(nonatomic,strong)UITextField *heightTextField;
@property(nonatomic,strong)UILabel * cmLabel;
@property(nonatomic,strong)UIImageView * secondImageView;
@property(nonatomic,strong)UITextField * weightTextField;
@property(nonatomic,strong)UILabel * kgLabel;
@end
