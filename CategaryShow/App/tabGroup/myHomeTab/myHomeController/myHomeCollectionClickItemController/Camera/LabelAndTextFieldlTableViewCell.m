//
//  LabelAndTextFieldlTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/15.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "LabelAndTextFieldlTableViewCell.h"
#import "MeasureLabelAndTextFieldModel.h"
@implementation LabelAndTextFieldlTableViewCell
{
    UILabel *titleName;
    UITextField *detailText;
    CGFloat initViewY;
    Boolean isViewYFisrt;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    .bottomSpaceToView(contentView, 15);
    [titleName setFont:[UIFont systemFontOfSize:15]];
    [titleName setTextColor:getUIColor(Color_measureTableTitle)];
    
    detailText = [UITextField new];
    detailText.delegate = self;
    [detailText setReturnKeyType:UIReturnKeyDone];
    [contentView addSubview:detailText];
    detailText.sd_layout
    .leftSpaceToView(titleName, 20)
    .centerYEqualToView(contentView)
    .widthIs(contentView.frame.size.width - 120)
    .heightIs(20);
    
    [detailText setFont:[UIFont systemFontOfSize:14]];
    
    UIView *linView = [UIView new];
    [contentView addSubview:linView];
    
    linView.sd_layout
    .leftSpaceToView(contentView, 10)
    .bottomEqualToView(contentView)
    .widthIs(SCREEN_WIDTH - 10)
    .heightIs(1);
    [linView setBackgroundColor:getUIColor(Color_background)];
    
    if (self.tag == 6) {
        
        detailText.keyboardType = UIKeyboardTypeNumberPad;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)name:@"UITextFieldTextDidChangeNotification" object:detailText];
    }
    
    
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (isViewYFisrt) {
        initViewY = self.superview.frame.origin.y;
        isViewYFisrt = NO;
    }
    
    int offset = [self getControlFrameOriginY:textField] + 64 + 45 + 25 - (self.superview.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.superview.frame = CGRectMake(0.0f, -offset, self.superview.frame.size.width, self.superview.frame.size.height);
    
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame = self.superview.frame;
    
    frame.origin.x = 0;
    frame.origin.y = initViewY;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    [self.superview setFrame:frame];
    
    [UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(textDetail::)]) {
        [_delegate textDetail:textField.text :self.tag];
    }
    
    //    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([_delegate respondsToSelector:@selector(textDetail::)]) {
        [_delegate textDetail:textField.text :self.tag];
    }
    return YES;
}





- (CGFloat) getControlFrameOriginY : (UIView *) curView {
    
    CGFloat resultY = 0;
    
    if ([curView superview] != nil && ![[curView superview] isEqual:self.superview]) {
        resultY = [self getControlFrameOriginY:[curView superview]];
    }
    
    return resultY + curView.frame.origin.y;
}



-(void)setModel:(MeasureLabelAndTextFieldModel *)model
{
    _model = model;
    [titleName setText:model.titleName];
    [detailText setPlaceholder:model.placeHolder];
    if ([_model.ContentText length] > 0) {
        [detailText setText:model.ContentText];
    }
    
    if (self.tag == 7) {
        [detailText setKeyboardType:UIKeyboardTypeNamePhonePad];
    } else {
        [detailText setKeyboardType:UIKeyboardTypeDefault];
    }
    
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 11)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:11];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:11];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 11)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
