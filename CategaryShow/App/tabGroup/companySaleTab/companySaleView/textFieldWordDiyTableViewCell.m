//
//  textFieldWordDiyTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/28.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "textFieldWordDiyTableViewCell.h"

@implementation textFieldWordDiyTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _wordDiy = [[UITextField alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH  - 24, 40)];
        if (_isenglish) {
            [_wordDiy setKeyboardType:UIKeyboardTypeEmailAddress];

        } else {
            [_wordDiy setKeyboardType:UIKeyboardTypeDefault];
        }
        _wordDiy.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_wordDiy];
        [_wordDiy.layer setCornerRadius:1];
        [_wordDiy.layer setMasksToBounds:YES];
        [_wordDiy.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_wordDiy.layer setBorderWidth:1];
        [_wordDiy setTextAlignment:NSTextAlignmentCenter];
        [_wordDiy setPlaceholder:@"输入绣花文字(限12字符)"];
        [_wordDiy setFont:[UIFont systemFontOfSize:14]];
        
    }
    
    return self;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
