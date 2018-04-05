//
//  QuickPhotoCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/4.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "QuickPhotoCell.h"

@implementation QuickPhotoCell
-(void)setModel:(photoModel *)model
{
    if ([model.photoName hasPrefix:@"http"]) {
        [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:model.photoName]];
    }
    else
    {
        [self.imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL,model.photoName]]];
    }
}
@end
