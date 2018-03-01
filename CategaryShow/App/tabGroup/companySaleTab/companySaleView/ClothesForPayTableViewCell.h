//
//  ClothesForPayTableViewCell.h
//  CategaryShow
//
//  Created by APPLE on 16/10/7.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClothesFroPay.h"
@interface ClothesForPayTableViewCell : UITableViewCell

@property (nonatomic, strong) ClothesFroPay *model;

@property (nonatomic, retain) UIButton *cutButton;
@property (nonatomic, retain) UIButton *upButton;

@end
