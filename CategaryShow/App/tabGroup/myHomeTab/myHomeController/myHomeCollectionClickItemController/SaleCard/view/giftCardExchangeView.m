//
//  alertViewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "giftCardExchangeView.h"

@interface giftCardExchangeView ()<UITextFieldDelegate>
@property (nonatomic, copy) giftCardExchage doneBlock;
@property (nonatomic, strong) UIView *backAlpha;

@property(nonatomic,strong) UITextField *cardText;
@property(nonatomic,strong) UITextField *codeText;
@property(nonatomic,strong) UIButton *done;
@end

@implementation giftCardExchangeView
static giftCardExchangeView *giftExchangeView = nil;

+(void)showGiftCardViewWithDoneBlock:(giftCardExchage)doneBlock{
    if (!giftExchangeView) {
        giftExchangeView = [[giftCardExchangeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) doneBlock:doneBlock];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:giftExchangeView];
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:.9
              initialSpringVelocity:0
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                             giftExchangeView.backAlpha.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
                         }
                         completion:^(BOOL finished) {
                         }];
        
    }
}
-(instancetype)initWithFrame:(CGRect)frame doneBlock:(giftCardExchage)doneBlock
{
    if (self==[super initWithFrame:frame]) {
        _doneBlock=doneBlock;
        [self createView];
    }
    return self;
}
-(void)createView
{
    UIView *backAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backAlpha setBackgroundColor:[UIColor blackColor]];
    [backAlpha setAlpha:0.5];
    [self addSubview:backAlpha];
    
    UIView *Popup = [UIView new];
    [self addSubview:Popup];
    Popup.sd_layout
    .leftSpaceToView(self, 37)
    .rightSpaceToView(self, 37)
    .bottomSpaceToView(self, 295)
    .heightIs(220);
    [Popup.layer setCornerRadius:5];
    [Popup.layer setMasksToBounds:YES];
    [Popup setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [UIView new];
    [Popup addSubview:lineView];
    lineView.sd_layout
    .bottomSpaceToView(Popup, 47)
    .heightIs(1)
    .rightEqualToView(Popup)
    .leftEqualToView(Popup);
    [lineView setBackgroundColor:getUIColor(Color_lightGrayLine)];
    [lineView setAlpha:0.8];
    
    UILabel *titleLabel = [UILabel new];
    [Popup addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(Popup, 20)
    .centerXEqualToView(Popup)
    .heightIs(20)
    .widthIs(100);
    [titleLabel setText:@"添加礼品卡"];
    [titleLabel setTextColor:[UIColor grayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    _cardText = [UITextField new];
    _cardText.delegate = self;
    [_cardText.layer setCornerRadius:3];
    [_cardText.layer setMasksToBounds:YES];
    [_cardText.layer setBorderColor:getUIColor(Color_lightGrayLine).CGColor];
    [_cardText.layer setBorderWidth:1];
    [_cardText setPlaceholder:@"请输入卡号"];
    [_cardText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [Popup addSubview:_cardText];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    _cardText.leftView = view;
    _cardText.leftViewMode = UITextFieldViewModeAlways;
    _cardText.sd_layout
    .topSpaceToView(titleLabel, 15)
    .rightSpaceToView(Popup, 25)
    .leftSpaceToView(Popup, 25)
    .heightIs(40);
    
    _codeText = [UITextField new];
    _codeText.delegate = self;
    [_codeText.layer setCornerRadius:3];
    [_codeText.layer setMasksToBounds:YES];
    [_codeText.layer setBorderColor:getUIColor(Color_lightGrayLine).CGColor];
    [_codeText.layer setBorderWidth:1];
    [_codeText setPlaceholder:@"请输入密码"];
    [_codeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [Popup addSubview:_codeText];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    _codeText.leftView = view2;
    _codeText.leftViewMode = UITextFieldViewModeAlways;
    _codeText.sd_layout
    .topSpaceToView(_cardText, 15)
    .rightSpaceToView(Popup, 25)
    .leftSpaceToView(Popup, 25)
    .heightIs(40);
    
    UIButton *Cancel = [UIButton new];
    [Popup addSubview:Cancel];
    Cancel.sd_layout
    .leftEqualToView(Popup)
    .heightIs(47)
    .widthIs(149)
    .bottomEqualToView(Popup);
    [Cancel setTitle:@"取消" forState:UIControlStateNormal];
    [Cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [Cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineV = [UIView new];
    [Popup addSubview:lineV];
    lineV.sd_layout
    .leftSpaceToView(Cancel, 0)
    .bottomEqualToView(Popup)
    .heightIs(47)
    .widthIs(1);
    [lineV setBackgroundColor:getUIColor(Color_lightGrayLine)];
    
    _done = [UIButton new];
    [Popup addSubview:_done];
    _done.sd_layout
    .rightEqualToView(Popup)
    .heightIs(47)
    .widthIs(149)
    .bottomEqualToView(Popup);
    [_done setTitle:@"绑定" forState:UIControlStateNormal];
    [_done setUserInteractionEnabled:NO];
    [_done setTitleColor:getUIColor(Color_lightGrayLine) forState:UIControlStateNormal];
    [_done.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_done addTarget:self action:@selector(adoneClickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissView{
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         self.backAlpha.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                     }
                     completion:^(BOOL finished) {
                         [giftExchangeView removeFromSuperview];
                         giftExchangeView = nil;
                     }];
}


-(void)textFieldDidChange :(UITextField *)textField{
    if (textField==_cardText) {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:20];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (textField.text.length > 15)
            {
                NSRange rangeIndex = [textField.text rangeOfComposedCharacterSequenceAtIndex:15];
                if (rangeIndex.length == 1)
                {
                    textField.text = [textField.text substringToIndex:15];
                }
                else
                {
                    NSRange rangeRange = [textField.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                    textField.text = [textField.text substringWithRange:rangeRange];
                }
            }
        }
    }
    else
    {
        if (textField.text.length > 0&&_cardText.text.length>0) {
            [_done setUserInteractionEnabled:YES];
            [_done setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [_done setUserInteractionEnabled:NO];
            [_done setTitleColor:getUIColor(Color_lightGrayLine) forState:UIControlStateNormal];
        }
    }
    
}
//
-(void)cancelClick
{
    [self dismissView];
}
//
-(void)adoneClickAction
{
    self.doneBlock(_cardText.text, _codeText.text);
    [self dismissView];
}

@end
