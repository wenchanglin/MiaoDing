//
//  JCFlipPage.h
//  JCFlipPageView
//
//  Created by ThreegeneDev on 14-8-8.
//  Copyright (c) 2014年 JimpleChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "designerModel.h"
static NSString const* kJCFlipPageDefaultReusableIdentifier = @"kJCFlipPageDefaultReusableIdentifier";


@interface JCFlipPage : UIView
@property (nonatomic, retain) designerModel *model;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) UILabel *tempContentLabel;
@property (nonatomic, retain) UIButton *designer;
@property (nonatomic, retain) UIButton *designerClothes;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;

- (void)setReuseIdentifier:(NSString *)identifier;


@end
