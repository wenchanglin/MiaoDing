//
//  addressAddTableViewCell.h
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/10.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"


@protocol AddressAddDelegate <NSObject>

-(void)clickChooseAddress:(NSInteger )item;
-(void)clickUpdateAddress:(NSInteger )item;
-(void)clickDeleteAddress:(NSInteger )item;

@end

@interface addressAddTableViewCell : UITableViewCell

@property (nonatomic, strong) id<AddressAddDelegate>delegate;



@property (nonatomic, retain) AddressModel* model;
@end
