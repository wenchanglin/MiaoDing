//
//  StoresPicCell.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/19.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresPicCell.h"

@implementation StoresPicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _picIMgView = [UIImageView new];
    _picIMgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_picIMgView];
    [_picIMgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
-(void)setmodel:(StoresDetailModel *)models WithIndex:(NSIndexPath *)indexPath{
    _models = models;
    _indexpath = indexPath;
    [_picIMgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL,models.data_img[indexPath.row]]]];
    [_picIMgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(SCREEN_WIDTH/[models.img_info[indexPath.row] floatValue]);
    }];
}
@end
