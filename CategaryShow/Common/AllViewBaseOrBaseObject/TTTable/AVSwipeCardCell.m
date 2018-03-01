//
//  AVSwipeCardCell.m
//  LZSwipeableViewDemo
//
//  Created by 周济 on 16/4/21.
//  Copyright © 2016年 LeoZ. All rights reserved.
//

#import "AVSwipeCardCell.h"

@interface AVSwipeCardCell ()
@property (nonatomic, strong) UIView  *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView  *descView;
@property (nonatomic, strong) UILabel *descLabel;
@end


@implementation AVSwipeCardCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithReuseIdentifier:@""]) {
        
    }
    return self;
}

- (void)setupSubviews{

    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headerView];
    
    UILabel *headerLabel = [UILabel new];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithHex:0x666666];
    headerLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.headerView addSubview:headerLabel];
    self.headerLabel = headerLabel;

    self.descView = [UIView new];
    self.descView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.descView];

    UILabel *contentLabel = [UILabel new];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 9;
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    contentLabel.textColor = [UIColor colorWithHex:0x333333];
    contentLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.descView addSubview:contentLabel];
    self.descLabel = contentLabel;
}


-(void)setCardInfo:(AVCardInfo *)cardInfo{
    _cardInfo = cardInfo;
    
    self.headerLabel.text = cardInfo.title;
    self.descLabel.text = cardInfo.summary;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.headerView.frame = CGRectMake(0, self.height - 44, self.width, 44);
    self.headerLabel.frame = self.headerView.bounds;
    
    self.descView.frame = CGRectMake(0, 0, self.width, self.height - 44);
    self.descLabel.frame = self.descView.bounds;
}



@end
