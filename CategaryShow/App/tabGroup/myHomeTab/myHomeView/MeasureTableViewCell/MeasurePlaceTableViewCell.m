//
//  MeasurePlaceTableViewCell.m
//  CategaryShow
//
//  Created by APPLE on 16/9/8.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MeasurePlaceTableViewCell.h"
#import "MeasureLabelAndTextFieldModel.h"
@implementation MeasurePlaceTableViewCell
{
    UILabel *titleName;
    UILabel *placeLabel;
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
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 12)
    .widthIs(80)
    .heightIs(20);
    [titleName setFont:Font_14];
    
    
    
    placeLabel = [UILabel new];
    [contentView addSubview:placeLabel];
    placeLabel.sd_layout
    .leftSpaceToView(titleName, 20)
    .topSpaceToView(contentView, 12)
    .widthIs(contentView.frame.size.width - 80)
    .heightIs(20);
    [placeLabel setFont:[UIFont systemFontOfSize:14]];
    
    detailText = [UITextView new];
    [detailText setReturnKeyType:UIReturnKeyDone];
    [detailText setDelegate:self];
//    [detailText.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
//    [detailText.layer setBorderWidth:1];
    detailText.tintColor = getUIColor(Color_loginBackViewColor);
    [contentView addSubview:detailText];
    detailText.sd_layout
    .leftSpaceToView(titleName, 17)
    .topSpaceToView(placeLabel,10)
    .rightSpaceToView(contentView, 10)
    .bottomSpaceToView(contentView, 10);
    [detailText setFont:[UIFont systemFontOfSize:14]];
    
    placeHolder = [UILabel new];
    [detailText addSubview:placeHolder];
    placeHolder.sd_layout
    .leftEqualToView(detailText)
    .topSpaceToView(detailText,5)
    .rightSpaceToView(detailText,5)
    .heightIs(15);
    [placeHolder setFont:[UIFont systemFontOfSize:14]];
    [placeHolder setTextColor:getUIColor(Color_WearClothesPlaceHolder)];
    
    
    UIView *linView = [UIView new];
    [contentView addSubview:linView];
    
    linView.sd_layout
    .leftSpaceToView(contentView, 10)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH - 10)
    .heightIs(1);
    [linView setBackgroundColor:getUIColor(Color_background)];
    
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
        
        [textView resignFirstResponder];
        
        if ([textView.text length] > 0) {
            [placeHolder setHidden:YES];
        } else {
            [placeHolder setHidden:NO];
        }
        
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
    
    
    
    //    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


-(void)textViewDidChange:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(placeDetail:)]) {
        [_delegate placeDetail:textView.text];
    }
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
    [placeLabel setText:[NSString stringWithFormat:@"%@%@%@",model.province,model.city,model.area]];
//    [detailText setPlaceholder:model.placeHolder];
    [placeHolder setText:model.placeHolder];
    if ([model.ContentText length] > 0) {
        [placeHolder setText:model.ContentText];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
