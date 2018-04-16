//
//  NewPhotoInfoTableViewCell.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/7/18.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "NewPhotoInfoTableViewCell.h"

@implementation NewPhotoInfoTableViewCell
{
    CGFloat initViewY;
    Boolean isViewYFisrt;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [UILabel new];
        [self.contentView addSubview:_titleLabel];
        
        _detailText = [UITextField new];
        [self.contentView addSubview:_detailText];
        
        _unitLabel = [UILabel new];
        [self.contentView addSubview:_unitLabel];
        
        
        
        
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 12)
    .centerYEqualToView(self.contentView)
    .heightIs(20)
    .widthIs(60);
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    _detailText.sd_layout
    .leftSpaceToView(_titleLabel, 15)
    .rightSpaceToView(self.contentView, 60)
    .centerYEqualToView(self.contentView)
    .heightIs(30);
    _detailText.delegate = self;
    [_detailText setFont:[UIFont systemFontOfSize:13]];
    _detailText.returnKeyType = UIReturnKeyDone;
    if (self.tag == 1) {
        [_detailText setKeyboardType:UIKeyboardTypeNamePhonePad];
    } else {
        [_detailText setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    _unitLabel.sd_layout
    .rightSpaceToView(self.contentView, 12)
    .centerYEqualToView(self.contentView)
    .heightIs(30)
    .widthIs(30);
    [_unitLabel setFont:[UIFont systemFontOfSize:14]];
    
    
    
    
}


//开始编辑输入框的时候，软键盘出现，执行此事件
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    if (isViewYFisrt) {
//        initViewY = self.superview.superview.superview.frame.origin.y;
//        isViewYFisrt = NO;
//    }
//
//    int offset = [self getControlFrameOriginY:textField] + 64 + 45 + 25 - (self.superview.superview.superview.frame.size.height - 216.0);//键盘高度216
//
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.superview.superview.frame = CGRectMake(0.0f, -offset, self.superview.superview.superview.frame.size.width, self.superview.superview.superview.frame.size.height);
//
//    [UIView commitAnimations];
//}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//
//
//    [textField resignFirstResponder];
//
//    return YES;
//}
//
////输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   // CGRect frame = self.superview.superview.superview.frame;

//    frame.origin.x = 0;
//    frame.origin.y = initViewY;
//
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    [self.superview.superview.superview setFrame:frame];
//
//    [UIView commitAnimations];

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

//- (CGFloat) getControlFrameOriginY : (UIView *) curView {
//
//    CGFloat resultY = 0;
//
//    if ([[[curView superview] superview] superview] != nil && ![[[[curView superview] superview] superview] isEqual:self.superview.superview.superview]) {
//        resultY = [self getControlFrameOriginY:[[[curView superview] superview] superview]];
//    }
//
//    return resultY + curView.frame.origin.y;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
