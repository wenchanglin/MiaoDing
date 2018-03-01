//
//  cameraUserInfoTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "cameraUserInfoTableViewCell.h"

@implementation cameraUserInfoTableViewCell

{
    UILabel *titleName;
    UITextField *detailText;
    CGFloat initViewY;
    Boolean isViewYFisrt;
    UIImageView *backImg;
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
    
    backImg = [UIImageView new];
    [contentView addSubview:backImg];
    backImg.sd_layout
    .leftSpaceToView(contentView, 12)
    .topSpaceToView(contentView, 5)
    .bottomSpaceToView(contentView, 5)
    .rightSpaceToView(contentView, 12);
    
    
    
    titleName = [UILabel new];
    [backImg addSubview:titleName];
    
    titleName.sd_layout
    .leftSpaceToView(backImg, 17)
    .centerYEqualToView(backImg)
    .widthIs(80)
    .heightIs(15);
    [titleName setFont:[UIFont boldSystemFontOfSize:20]];
    [titleName setTextColor:[UIColor blackColor]];
    [titleName setTextAlignment:NSTextAlignmentLeft];
    
    detailText = [UITextField new];
    detailText.delegate = self;
    [detailText setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [detailText setReturnKeyType:UIReturnKeyDone];
    [contentView addSubview:detailText];
    detailText.sd_layout
    .leftSpaceToView(titleName, 20)
    .centerYEqualToView(contentView)
    .rightSpaceToView(contentView, 45)
    .heightIs(38);
    [detailText setTextAlignment:NSTextAlignmentCenter];
    [detailText setFont:[UIFont systemFontOfSize:14]];
    [detailText.layer setCornerRadius:3];
    [detailText.layer setMasksToBounds:YES];
  
    
 
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
    
    [backImg setImage:[UIImage imageNamed:model.backImg]];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
