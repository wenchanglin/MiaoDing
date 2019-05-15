//
//  mcYuYueListTableViewCell.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/30.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "mcYuYueListTableViewCell.h"

@implementation mcYuYueListTableViewCell
{
    UILabel *titleLabel;
    UILabel *textContent;
    UILabel *timeLable;
    UILabel *companyName;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createContentView];
        
    }
    return self;
}

-(void)createContentView
{
    UIView *contentView = self.contentView;
    titleLabel = [UILabel new];
    [titleLabel setText:@"亲爱的用户"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    
    textContent = [UILabel new];
    textContent.numberOfLines=0;
    [textContent setFont:[UIFont systemFontOfSize:12]];
    [contentView addSubview:textContent];
    [textContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
    }];

    timeLable = [UILabel new];
    [contentView addSubview:timeLable];
    [timeLable setTextAlignment:NSTextAlignmentRight];
    [timeLable setFont:[UIFont systemFontOfSize:12]];
    timeLable.textColor = [UIColor colorWithHexString:@"#888888"];
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textContent.mas_bottom).offset(10);
        make.left.right.equalTo(textContent);
        make.height.mas_equalTo(15);
    }];
    companyName = [UILabel new];
    [contentView addSubview:companyName];
    [companyName setTextAlignment:NSTextAlignmentRight];
    [companyName setFont:[UIFont systemFontOfSize:12]];
    companyName.textColor = [UIColor colorWithHexString:@"#888888"];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(timeLable);
        make.top.equalTo(timeLable.mas_bottom);
        make.bottom.mas_equalTo(-14);
    }];
}

-(void)setModel:(messageListModel *)model
{
    _model = model;
    
    NSString *_test  = model.content;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
//    CGFloat emptylen = textContent.font.pointSize * 2;
//    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    textContent.attributedText = attrText;
    
    [timeLable setText:model.create_time];
    [companyName setText:@"杭州云工场科技有限公司"];
}

@end
