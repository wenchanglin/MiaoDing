//
//  Card.m
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "XLCard.h"
#import "XLCardItem.h"

@interface XLCard () {
    UIImageView *_imageView;
    UILabel *_textLabel;
    UILabel *_tagLabel;
}
@end

@implementation XLCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.layer.cornerRadius = 7.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *ViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 76, self.bounds.size.width, self.bounds.size.height - 76)];
//    [ViewBack setBackgroundColor:[UIColor whiteColor]];
    [ViewBack setImage:[UIImage imageNamed:@"designerCard"]];
    [ViewBack.layer setCornerRadius:7.0];
    [ViewBack.layer setMasksToBounds:YES];
    [self addSubview:ViewBack];
    
    CGFloat labelHeight = 85.0;
    CGFloat imageViewHeight = self.bounds.size.height - labelHeight;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, self.bounds.size.width - 50, imageViewHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    [_imageView.layer setCornerRadius:7];
    [self addSubview:_imageView];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewHeight + 9, self.bounds.size.width, 20)];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:18];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_textLabel];
    
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewHeight + 40, self.bounds.size.width, 20)];
    _tagLabel.textColor = [UIColor lightGrayColor];
    _tagLabel.font = [UIFont systemFontOfSize:13];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_tagLabel];
    
}

-(void)setItem:(XLCardItem *)item {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, item.avatar]]];
    _textLabel.text = item.name;
    _tagLabel.text = item.tag;
}

@end
