//
//  LiangTiTwoRowReusableView.h
//  CategaryShow
//
//  Created by 文长林 on 2019/5/5.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiangTiTwoRowReusableView : UICollectionReusableView
@property(nonatomic,strong)UILabel* titleLabels;
@property(nonatomic,strong)UIButton*firstBtn;
@property(nonatomic,strong)UIImageView*zuoHuaImageView;
@property(nonatomic,strong)UIButton*twoBtn;
@property(nonatomic,strong)UILabel* endLabel;

@end

NS_ASSUME_NONNULL_END
