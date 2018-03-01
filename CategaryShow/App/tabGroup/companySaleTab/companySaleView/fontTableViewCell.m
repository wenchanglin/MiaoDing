//
//  fontTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "fontTableViewCell.h"

@implementation fontTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _fontArray = [NSMutableArray array];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setUp];

}

-(void)setUp
{
    for (int i = 0; i < [_fontArray count]; i ++) {
        UIButton *btnFont = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 - 61 + (self.frame.size.width / 2) * i, self.frame.size.height / 2 - 30, 122, 35)];
        [self.contentView addSubview:btnFont];
        
        [btnFont.layer setCornerRadius:25];
        [btnFont.layer setMasksToBounds:YES];
        
        [btnFont setTag:i + 2];
        [btnFont addTarget:self action:@selector(fontClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 122, 35)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_fontArray[i] stringForKey:@"img"]]]];
        [btnFont addSubview:img];
        [img.layer setCornerRadius:25];
        [img.layer setMasksToBounds:YES];
        
        
        UIImageView *imageFront = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 - 61 + (self.frame.size.width / 2) * i, self.frame.size.height / 2 - 30, 122, 35)];
        [imageFront setTag:i + 10];
        [self.contentView addSubview:imageFront];
        if (i == 0) {
            [imageFront setImage:[UIImage imageNamed:@"fontChoose"]];
        } else {
            [imageFront setImage:[UIImage imageNamed:@"font"]];

        }
        
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 - 61 + (self.frame.size.width / 2) * i, self.frame.size.height / 2 + 10, 122, 20)];
        [labelName setTextAlignment:NSTextAlignmentCenter];
        [labelName setText:[_fontArray[i] stringForKey:@"name"]];
        [labelName setFont:[UIFont systemFontOfSize:12]];
        [labelName setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:labelName];
//        [imageFront.layer setCornerRadius:25];
//        [imageFront.layer setMasksToBounds:YES];
        
        
    }
}

-(void)fontClick:(UIButton *)sender
{
    if (sender.tag == 2) {
        UIImageView *img = [self.contentView viewWithTag:10];
        [img setImage:[UIImage imageNamed:@"fontChoose"]];
        
        
        UIImageView *imge = [self.contentView viewWithTag:11];
        [imge setImage:[UIImage imageNamed:@"font"]];
    } else {
        UIImageView *img = [self.contentView viewWithTag:11];
        [img setImage:[UIImage imageNamed:@"fontChoose"]];
        
        
        UIImageView *imge = [self.contentView viewWithTag:10];
        [imge setImage:[UIImage imageNamed:@"font"]];
    }
    
    
    if ([_delegate respondsToSelector:@selector(fontChoose:)]) {
        [_delegate fontChoose:sender.tag - 2];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
