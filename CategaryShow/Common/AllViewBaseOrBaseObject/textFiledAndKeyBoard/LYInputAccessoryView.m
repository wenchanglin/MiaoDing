//
//  LYInputAccessoryView.m
//  intputView&KeyboardAccessory
//
//  Created by chairman on 16/4/20.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "LYInputAccessoryView.h"

#define windowRect [UIScreen mainScreen].bounds

NSUInteger const FontSize = 17.0;

@interface LYInputAccessoryView()
<
UITextViewDelegate
>
@property (nonatomic, assign,getter=isChanged) BOOL changed;
@property (nonatomic, assign) CGFloat originTextViewWidth;

@end

@implementation LYInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowRect.size.width, 1)];
        [line setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
        [self addSubview:line];
        self.backgroundColor = [UIColor whiteColor];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, windowRect.size.width - 10, self.frame.size.height - 10)];
        [_textView.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
        [_textView.layer setBorderWidth:1];
        [_textView.layer setCornerRadius:2];
        [_textView.layer setMasksToBounds:YES];
        [self addSubview:self.textView];
        self.textView.font = [UIFont systemFontOfSize:FontSize];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeySend;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - UITextViewDelegate
//* 如果是懒加载的在这里获取的width不正确 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.originTextViewWidth==0) {
        self.originTextViewWidth = textView.bounds.size.width;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize  textSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]}];
    CGFloat textWidth = textSize.width+10;
    if (textWidth < self.textView.bounds.size.width) {
        if (self.isChanged) {
            //* 回到最初 */
            [self updateSelfOfTextViewSize];
        }
        self.changed=NO;
    } else {
        //* 换行了 */
        self.changed = YES;
        [self updateSelfOfTextViewSize];
    }
}
#pragma mark - 更新输入框、本身View大小
- (void)updateSelfOfTextViewSize {
    [UIView animateWithDuration:.3 animations:^{
        //* 当UITextView的高度大于100的时候不在增加高度,模仿微信 */
        if (self.textView.bounds.size.height>100) {
            return ;
        }
        //* TextView 大小*/
        CGRect bounds = self.textView.bounds;
        CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
        CGSize newSize = [self.textView sizeThatFits:maxSize];
        self.textView.frame = CGRectMake(10, 10, self.originTextViewWidth, newSize.height);
        
        //*本身View 大小*/
        CGRect rect = self.frame;
//        NSLog(@"self.textView.frame = %@",NSStringFromCGRect(self.textView.frame));
        //* 10*2 为 上下Margin  */
        rect.size.height = self.textView.frame.size.height+10*2;
        //* 当前的y －（这个Accessory的height － 本身的height）。 其本质是向上(Y轴)移动增加的height*/
        rect.origin.y = rect.origin.y-(rect.size.height-self.frame.size.height);
        self.frame = rect;
    }];
}

- (void)becomeFirstResponderForInputeTextView  {
    if (![self.textView isFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (void)keyboardWillShow {
    [self becomeFirstResponderForInputeTextView];
}


@end
