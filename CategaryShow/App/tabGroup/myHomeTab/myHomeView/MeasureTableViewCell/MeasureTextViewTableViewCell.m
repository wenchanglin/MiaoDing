//
//  MeasureTextViewTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MeasureTextViewTableViewCell.h"

@implementation MeasureTextViewTableViewCell
{
    UILabel *titleName;
    UITextView *detailText;
    CGFloat initViewY;
    Boolean isViewYFisrt;
    UILabel *placeHolder;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        isViewYFisrt = YES;
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIView *contentView = self.contentView;
    titleName = [UILabel new];
    [contentView addSubview:titleName];
    
    titleName.sd_layout
    .leftSpaceToView(contentView, 28)
    .topSpaceToView(contentView, 15)
    .widthIs(80)
    .heightIs(16);
    [titleName setFont:[UIFont systemFontOfSize:15]];
    [titleName setTextColor:getUIColor(Color_measureTableTitle)];
    
    detailText = [UITextView new];
    detailText.delegate = self;
    [contentView addSubview:detailText];
//    [detailText.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
//    [detailText.layer setBorderWidth:1];
    detailText.tintColor = getUIColor(Color_loginBackViewColor);
    detailText.sd_layout
    .leftSpaceToView(titleName, 20)
    .topSpaceToView(contentView, 15)
    .rightSpaceToView(contentView, 15)
    .bottomSpaceToView(contentView, 10);
    [detailText setFont:[UIFont systemFontOfSize:14]];
    
    placeHolder = [UILabel new];
    [detailText addSubview:placeHolder];
    placeHolder.sd_layout
    .leftEqualToView(detailText)
    .topEqualToView(detailText)
    .rightSpaceToView(detailText,5)
    .heightIs(35);
    [placeHolder setFont:[UIFont systemFontOfSize:14]];
    [placeHolder setNumberOfLines:0];
    [placeHolder setTextColor:getUIColor(Color_WearClothesPlaceHolder)];
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [placeHolder setHidden:YES];
    
    if (isViewYFisrt) {
        initViewY = self.superview.superview.frame.origin.y;
        isViewYFisrt = NO;
    }
    
    int offset = [self getControlFrameOriginY:textView] - (self.superview.frame.size.height - 216);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.superview.superview.frame = CGRectMake(0.0f, -offset, self.superview.superview.frame.size.width, self.superview.superview.frame.size.height);
    
    [UIView commitAnimations];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        if (textView.text.length > 0) {
            [placeHolder setHidden:YES];
        } else {
            [placeHolder setHidden:NO];
        }
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect frame = self.superview.superview.frame;
    
    frame.origin.x = 0;
    frame.origin.y = initViewY;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    [self.superview.superview setFrame:frame];
    
    [UIView commitAnimations];
    
    
    if ([_delegata respondsToSelector:@selector(remarkDetail:)]) {
        
        [_delegata remarkDetail:textView.text];
    }
    
    //    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (CGFloat) getControlFrameOriginY : (UIView *) curView {
    
    CGFloat resultY = 0;
    
    if ([curView superview] != nil && ![[curView superview] isEqual:self.superview]) {
        resultY = [self getControlFrameOriginY:[curView superview]];
    }
    
    return resultY + curView.frame.origin.y + 50;
}

-(void)setModel:(MeasureLabelAndTextFieldModel *)model
{
    _model = model;
    [titleName setText:model.titleName];
    [placeHolder setText:model.placeHolder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
