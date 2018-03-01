//
//  DontHaveThreeImageTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "DontHaveThreeImageTableViewCell.h"
#import "MainTabModel.h"
@implementation DontHaveThreeImageTableViewCell

{
    UIImageView *imageView;
    UILabel *timeLabel;
    UILabel *titleLabel;
    UILabel *fenLeiLabel;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
    }
    
    return self;
}

-(void)setUp {
    
     UIView *contentView = self.contentView;

    
    imageView = [UIImageView new];
    [self.contentView addSubview:imageView];
    imageView.sd_layout
    .topSpaceToView(contentView,0)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(336 / 2);
    
//    titleLabel = [UILabel new];
//    [self.contentView addSubview:titleLabel];
//    titleLabel.sd_layout
//    .topSpaceToView(contentView,40)
//    .leftEqualToView(contentView)
//    .rightEqualToView(contentView)
//    .heightIs(40);
//    titleLabel.center = self.contentView.center;
//    titleLabel.font = [UIFont boldSystemFontOfSize:24];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    
//    fenLeiLabel = [UILabel new];
//    [self.contentView addSubview:fenLeiLabel];
//    fenLeiLabel.sd_layout
//    .topSpaceToView(titleLabel,10)
//    .leftEqualToView(contentView)
//    .rightEqualToView(contentView)
//    .heightIs(30);
//    fenLeiLabel.font = [UIFont boldSystemFontOfSize:18];
//    fenLeiLabel.textColor = [UIColor whiteColor];
//    fenLeiLabel.textAlignment = NSTextAlignmentCenter;
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
    
}


-(void)setModel:(MainTabModel *)model
{
    _model = model;

    [timeLabel setText:model.time];
    [fenLeiLabel setText:[NSString stringWithFormat:@"- %@ -", model.fenLei]];
    [titleLabel setText:model.titleContent];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model.ImageUrl]]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView.layer setMasksToBounds:YES];
    [self setupAutoHeightWithBottomView:imageView bottomMargin:0];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
